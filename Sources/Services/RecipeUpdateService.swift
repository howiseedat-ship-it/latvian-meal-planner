import Foundation

final class RecipeUpdateService {
    static let shared = RecipeUpdateService()

    // Replace with your actual GitHub repo URL
    private let recipesURL = URL(string: "https://raw.githubusercontent.com/yourusername/latvian-meal-planner-recipes/main/recipes.json")!
    private let versionKey = "recipes_version"
    private let recipesCacheKey = "recipes_cache"
    private let lastUpdateKey = "recipes_last_update"
    private let minUpdateIntervalHours = 24

    private init() {}

    func checkForUpdates() async {
        let lastUpdate = UserDefaults.standard.double(forKey: lastUpdateKey)
        let now = Date().timeIntervalSince1970
        if now - lastUpdate < Double(minUpdateIntervalHours) * 3600 {
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: recipesURL)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }

            let remoteVersion = String(data: data, encoding: .utf8)?.prefix(64) ?? ""
            let localVersion = UserDefaults.standard.string(forKey: versionKey) ?? ""

            guard remoteVersion != localVersion else { return }

            let decoded = try JSONDecoder().decode([Recipe].self, from: data)
            guard !decoded.isEmpty else { return }

            UserDefaults.standard.set(remoteVersion, forKey: versionKey)
            UserDefaults.standard.set(data, forKey: recipesCacheKey)
            UserDefaults.standard.set(now, forKey: lastUpdateKey)

            RecipeService.shared.clearCache()
        } catch {
            print("Recipe update failed: \(error)")
        }
    }

    func loadCachedRecipes() -> [Recipe]? {
        guard let data = UserDefaults.standard.data(forKey: recipesCacheKey) else {
            return nil
        }
        do {
            return try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            return nil
        }
    }

    func lastUpdateDate() -> Date? {
        let timestamp = UserDefaults.standard.double(forKey: lastUpdateKey)
        guard timestamp > 0 else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }
}
