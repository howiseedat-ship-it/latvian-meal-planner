import Foundation

final class ShoppingListService {
    static let shared = ShoppingListService()

    private init() {}

    func generateShoppingList(fromRecipes recipes: [Recipe], servingsPerRecipe: [UUID: Int] = [:]) -> ShoppingList {
        var ingredientTotals: [String: (quantity: Double, unit: String)] = [:]

        for recipe in recipes {
            let servings = servingsPerRecipe[recipe.id] ?? recipe.servings
            let factor = Double(servings) / Double(recipe.servings)

            for ingredient in recipe.ingredients {
                let key = ingredient.ingredientName.lowercased()
                let scaledQuantity = ingredient.quantity * factor
                if var existing = ingredientTotals[key] {
                    existing.quantity += scaledQuantity
                    ingredientTotals[key] = existing
                } else {
                    ingredientTotals[key] = (scaledQuantity, ingredient.unit)
                }
            }
        }

        let items = ingredientTotals.map { key, value in
            ShoppingItem(
                ingredientName: key.capitalized,
                quantity: round(value.quantity * 10) / 10,
                unit: value.unit
            )
        }

        let name = "Shopping List - \(Date().formatted(date: .abbreviated, time: .omitted))"
        return ShoppingList(name: name, items: items)
    }

    func generateShoppingList(fromMealPlan mealPlan: MealPlan) -> ShoppingList {
        var recipes: [Recipe] = []
        var servingsPerRecipe: [UUID: Int] = [:]

        for meal in mealPlan.meals {
            if let recipe = RecipeService.shared.loadRecipes().first(where: { $0.id == meal.recipeId }) {
                recipes.append(recipe)
                servingsPerRecipe[recipe.id] = meal.servings
            }
        }

        return generateShoppingList(fromRecipes: recipes, servingsPerRecipe: servingsPerRecipe)
    }

    func generateShoppingList(fromMissingIngredients missing: [RecipeIngredient]) -> ShoppingList {
        let items = missing.map { ingredient in
            ShoppingItem(
                ingredientName: ingredient.ingredientName,
                quantity: ingredient.quantity,
                unit: ingredient.unit
            )
        }
        let name = "Missing Ingredients - \(Date().formatted(date: .abbreviated, time: .omitted))"
        return ShoppingList(name: name, items: items)
    }

    func addStorePrices(to list: ShoppingList, prices: [String: StorePrice]) -> ShoppingList {
        let updatedItems = list.items.map { item in
            if let price = prices[item.ingredientName.lowercased()] {
                return ShoppingItem(
                    id: item.id,
                    ingredientName: item.ingredientName,
                    quantity: item.quantity,
                    unit: item.unit,
                    store: price.store,
                    price: price.price * item.quantity,
                    isPurchased: item.isPurchased,
                    sourceRecipeId: item.sourceRecipeId
                )
            }
            return item
        }
        return ShoppingList(
            id: list.id,
            name: list.name,
            items: updatedItems,
            createdAt: list.createdAt
        )
    }
}
