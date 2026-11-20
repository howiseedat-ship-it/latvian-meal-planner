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
                HomeView()
                    .tabItem {
                        Label("Меню", systemImage: "house.fill")
                    }

                RecipeSearchView()
                    .tabItem {
                        Label("Рецепты", systemImage: "book.fill")
                    }

                MealPlanView()
                    .tabItem {
                        Label("План", systemImage: "calendar")
                    }

                ShoppingListView()
                    .tabItem {
                        Label("Покупки", systemImage: "cart.fill")
                    }
            }
        }
    }
}
