import SwiftUI

@main
struct LatvianMealPlannerApp: App {
    init() {
        Task {
            await RecipeUpdateService.shared.checkForUpdates()
        }
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Меню", systemImage: "house.fill")
                }

                NavigationStack {
                    RecipeSearchView()
                }
                .tabItem {
                    Label("Рецепты", systemImage: "book.fill")
                }

                NavigationStack {
                    MealPlanView()
                }
                .tabItem {
                    Label("План", systemImage: "calendar")
                }

                NavigationStack {
                    ShoppingListView()
                }
                .tabItem {
                    Label("Покупки", systemImage: "cart.fill")
                }
            }
        }
    }
}
