import Foundation

final class RecipeService {
    static let shared = RecipeService()

    private var cachedRecipes: [Recipe]?

    private init() {}

    func loadRecipes() -> [Recipe] {
        if let cached = cachedRecipes {
            return cached
        }

        var recipes: [Recipe] = []

        if let updated = RecipeUpdateService.shared.loadCachedRecipes() {
            recipes = updated
        }

        if recipes.isEmpty {
            if let bundleURL = Bundle.main.url(forResource: "recipes", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: bundleURL)
                    let decoded = try JSONDecoder().decode([Recipe].self, from: data)
                    recipes = decoded
                } catch {
                    print("Failed to load recipes from bundle: \(error)")
                }
            }
        }

        if recipes.isEmpty {
            recipes = RecipeDatabase.shared.allRecipes()
        }

        cachedRecipes = recipes
        return recipes
    }

    func searchRecipes(query: String) -> [Recipe] {
        let all = loadRecipes()
        let lowerQuery = query.lowercased()
        return all.filter { recipe in
            recipe.name.lowercased().contains(lowerQuery) ||
            recipe.nameLV.lowercased().contains(lowerQuery) ||
            recipe.description.lowercased().contains(lowerQuery) ||
            recipe.ingredients.contains { $0.ingredientName.lowercased().contains(lowerQuery) }
        }
    }

    func recipes(forIngredients ingredientNames: [String]) -> [RecipeMatch] {
        let all = loadRecipes()
        let lowerIngredients = Set(ingredientNames.map { $0.lowercased() })
        var matches: [RecipeMatch] = []

        for recipe in all {
            let recipeIngredients = Set(recipe.ingredients.map { $0.ingredientName.lowercased() })
            let matchingIngredients = recipeIngredients.intersection(lowerIngredients)
            let matchCount = matchingIngredients.count
            let totalIngredients = recipeIngredients.count

            guard totalIngredients > 0 else { continue }
            let matchRatio = Double(matchCount) / Double(totalIngredients)

            let missingIngredients = recipe.ingredients.filter {
                !lowerIngredients.contains($0.ingredientName.lowercased())
            }

            matches.append(RecipeMatch(
                recipe: recipe,
                matchCount: matchCount,
                totalIngredients: totalIngredients,
                matchRatio: matchRatio,
                missingIngredients: missingIngredients
            ))
        }

        return matches.sorted { $0.matchRatio > $1.matchRatio }
    }

    func recipesWithEquipment(_ equipment: Set<KitchenEquipment>) -> [Recipe] {
        let all = loadRecipes()
        return all.filter { recipe in
            Set(recipe.equipment).isSubset(of: equipment)
        }
    }

    func recipesForServings(_ servings: Int) -> [Recipe] {
        let all = loadRecipes()
        return all.filter { $0.servings == servings }
    }

    func scaledRecipe(_ recipe: Recipe, servings: Int) -> Recipe {
        guard servings > 0 else { return recipe }
        let factor = Double(servings) / Double(recipe.servings)
        let scaledIngredients = recipe.ingredients.map { ingredient in
            RecipeIngredient(
                id: ingredient.id,
                ingredientName: ingredient.ingredientName,
                quantity: round(ingredient.quantity * factor * 10) / 10,
                unit: ingredient.unit,
                isOptional: ingredient.isOptional
            )
        }
        return Recipe(
            id: recipe.id,
            name: recipe.name,
            nameLV: recipe.nameLV,
            description: recipe.description,
            ingredients: scaledIngredients,
            steps: recipe.steps,
            prepTimeMinutes: recipe.prepTimeMinutes,
            cookTimeMinutes: recipe.cookTimeMinutes,
            servings: servings,
            caloriesPerServing: recipe.caloriesPerServing,
            proteinPerServing: recipe.proteinPerServing,
            carbsPerServing: recipe.carbsPerServing,
            fatsPerServing: recipe.fatsPerServing,
            dietaryTags: recipe.dietaryTags,
            cuisine: recipe.cuisine,
            difficulty: recipe.difficulty,
            equipment: recipe.equipment,
            imageUrl: recipe.imageUrl
        )
    }

    func fiveIngredientRecipes() -> [Recipe] {
        let all = loadRecipes()
        return all.filter { $0.ingredients.count <= 5 }
    }

    func clearCache() {
        cachedRecipes = nil
    }
}

struct RecipeMatch {
    let recipe: Recipe
    let matchCount: Int
    let totalIngredients: Int
    let matchRatio: Double
    let missingIngredients: [RecipeIngredient]
}
