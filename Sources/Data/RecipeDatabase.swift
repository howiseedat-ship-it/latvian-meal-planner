import Foundation

final class RecipeDatabase {
    static let shared = RecipeDatabase()

    private let recipes: [Recipe]

    private init() {
        recipes = Self.buildInitialRecipes()
    }

    func allRecipes() -> [Recipe] {
        recipes
    }

    func recipe(byId id: UUID) -> Recipe? {
        recipes.first { $0.id == id }
    }

    func searchRecipes(query: String) -> [Recipe] {
        let lowerQuery = query.lowercased()
        return recipes.filter { recipe in
            recipe.name.lowercased().contains(lowerQuery) ||
            recipe.nameLV.lowercased().contains(lowerQuery) ||
            recipe.description.lowercased().contains(lowerQuery) ||
            recipe.ingredients.contains { $0.ingredientName.lowercased().contains(lowerQuery) }
        }
    }

    func recipes(forIngredients ingredientNames: [String]) -> [RecipeMatch] {
        let lowerIngredients = Set(ingredientNames.map { $0.lowercased() })
        var matches: [RecipeMatch] = []

        for recipe in recipes {
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

    private static func buildInitialRecipes() -> [Recipe] {
        [
            Recipe(
                id: UUID(uuidString: "A0000000-0000-0000-0000-000000000001")!,
                name: "Chicken Pasta with Tomatoes",
                nameLV: "Vistas makaroni ar tomātiem",
                description: "Simple and delicious pasta with chicken and fresh tomatoes.",
                ingredients: [
                    RecipeIngredient(ingredientName: "chicken breast", quantity: 300, unit: "g"),
                    RecipeIngredient(ingredientName: "pasta", quantity: 250, unit: "g"),
                    RecipeIngredient(ingredientName: "tomatoes", quantity: 3, unit: "pcs"),
                    RecipeIngredient(ingredientName: "onion", quantity: 1, unit: "pcs"),
                    RecipeIngredient(ingredientName: "garlic", quantity: 3, unit: "cloves"),
                    RecipeIngredient(ingredientName: "olive oil", quantity: 2, unit: "tbsp"),
                    RecipeIngredient(ingredientName: "salt", quantity: 1, unit: "tsp"),
                    RecipeIngredient(ingredientName: "black pepper", quantity: 0.5, unit: "tsp"),
                    RecipeIngredient(ingredientName: "basil", quantity: 5, unit: "leaves")
                ],
                steps: [
                    "Cook pasta according to package instructions.",
                    "Cut chicken breast into cubes and season with salt and pepper.",
                    "Heat olive oil in a pan and sauté chicken until golden.",
                    "Add chopped onion and garlic, cook for 2 minutes.",
                    "Add diced tomatoes and simmer for 10 minutes.",
                    "Combine pasta with the chicken-tomato sauce.",
                    "Garnish with fresh basil and serve."
                ],
                prepTimeMinutes: 15,
                cookTimeMinutes: 25,
                servings: 2,
                caloriesPerServing: 520,
                proteinPerServing: 38,
                carbsPerServing: 55,
                fatsPerServing: 15,
                dietaryTags: [],
                cuisine: "Italian",
                difficulty: .easy
            ),
            Recipe(
                id: UUID(uuidString: "A0000000-0000-0000-0000-000000000002")!,
                name: "Beef Goulash",
                nameLV: "Liello gaļas gulāšs",
                description: "Traditional hearty beef goulash with potatoes and vegetables.",
                ingredients: [
                    RecipeIngredient(ingredientName: "beef", quantity: 500, unit: "g"),
                    RecipeIngredient(ingredientName: "potatoes", quantity: 4, unit: "pcs"),
                    RecipeIngredient(ingredientName: "onion", quantity: 2, unit: "pcs"),
                    RecipeIngredient(ingredientName: "carrot", quantity: 2, unit: "pcs"),
                    RecipeIngredient(ingredientName: "tomato paste", quantity: 2, unit: "tbsp"),
                    RecipeIngredient(ingredientName: "paprika", quantity: 1, unit: "tsp"),
                    RecipeIngredient(ingredientName: "beef broth", quantity: 500, unit: "ml"),
                    RecipeIngredient(ingredientName: "salt", quantity: 1, unit: "tsp"),
                    RecipeIngredient(ingredientName: "black pepper", quantity: 0.5, unit: "tsp"),
                    RecipeIngredient(ingredientName: "vegetable oil", quantity: 2, unit: "tbsp")
                ],
                steps: [
                    "Cut beef into 2cm cubes and season with salt and pepper.",
                    "Heat oil in a large pot and brown the beef on all sides.",
                    "Add chopped onions and carrots, cook for 5 minutes.",
                    "Add tomato paste and paprika, stir for 1 minute.",
                    "Pour in beef broth and bring to a boil.",
                    "Reduce heat and simmer for 1.5 hours until beef is tender.",
                    "Add diced potatoes and cook for 20 more minutes.",
                    "Serve hot with bread or rice."
                ],
                prepTimeMinutes: 20,
                cookTimeMinutes: 110,
                servings: 4,
                caloriesPerServing: 480,
                proteinPerServing: 42,
                carbsPerServing: 35,
                fatsPerServing: 20,
                dietaryTags: [],
                cuisine: "Hungarian",
                difficulty: .medium
            ),
            Recipe(
                id: UUID(uuidString: "A0000000-0000-0000-0000-000000000003")!,
                name: "Vegetable Stir Fry",
                nameLV: "Dārzeņu vārījums",
                description: "Quick and healthy vegetable stir fry with soy sauce.",
                ingredients: [
                    RecipeIngredient(ingredientName: "broccoli", quantity: 200, unit: "g"),
                    RecipeIngredient(ingredientName: "bell pepper", quantity: 2, unit: "pcs"),
                    RecipeIngredient(ingredientName: "carrot", quantity: 2, unit: "pcs"),
                    RecipeIngredient(ingredientName: "soy sauce", quantity: 3, unit: "tbsp"),
                    RecipeIngredient(ingredientName: "garlic", quantity: 3, unit: "cloves"),
                    RecipeIngredient(ingredientName: "ginger", quantity: 1, unit: "tbsp"),
                    RecipeIngredient(ingredientName: "sesame oil", quantity: 1, unit: "tbsp"),
                    RecipeIngredient(ingredientName: "rice", quantity: 200, unit: "g"),
                    RecipeIngredient(ingredientName: "salt", quantity: 0.5, unit: "tsp")
                ],
                steps: [
                    "Cook rice according to package instructions.",
                    "Cut all vegetables into bite-sized pieces.",
                    "Heat sesame oil in a wok or large pan.",
                    "Add garlic and ginger, stir for 30 seconds.",
                    "Add vegetables and stir fry for 5-7 minutes.",
                    "Add soy sauce and cook for 2 more minutes.",
                    "Serve over rice."
                ],
                prepTimeMinutes: 15,
                cookTimeMinutes: 15,
                servings: 2,
                caloriesPerServing: 380,
                proteinPerServing: 12,
                carbsPerServing: 65,
                fatsPerServing: 8,
                dietaryTags: [.vegetarian, .vegan],
                cuisine: "Asian",
                difficulty: .easy
            ),
            Recipe(
                id: UUID(uuidString: "A0000000-0000-0000-0000-000000000004")!,
                name: "Latvian Potato Soup",
                nameLV: "Zupmaize ar kartupeļiem",
                description: "Traditional Latvian potato soup with smoked sausage.",
                ingredients: [
                    RecipeIngredient(ingredientName: "potatoes", quantity: 5, unit: "pcs"),
                    RecipeIngredient(ingredientName: "onion", quantity: 1, unit: "pcs"),
                    RecipeIngredient(ingredientName: "carrot", quantity: 1, unit: "pcs"),
                    RecipeIngredient(ingredientName: "smoked sausage", quantity: 150, unit: "g"),
                    RecipeIngredient(ingredientName: "bacon", quantity: 50, unit: "g"),
                    RecipeIngredient(ingredientName: "vegetable broth", quantity: 1000, unit: "ml"),
                    RecipeIngredient(ingredientName: "dill", quantity: 2, unit: "tbsp"),
                    RecipeIngredient(ingredientName: "salt", quantity: 1, unit: "tsp"),
                    RecipeIngredient(ingredientName: "black pepper", quantity: 0.5, unit: "tsp")
                ],
                steps: [
                    "Dice potatoes and cut sausage into small pieces.",
                    "Chop onion and carrot, dice bacon.",
                    "Fry bacon and onion in a pot for 3 minutes.",
                    "Add carrot and cook for 2 more minutes.",
                    "Add potatoes and broth, bring to a boil.",
                    "Simmer for 20 minutes until potatoes are tender.",
                    "Add sausage and cook for 5 more minutes.",
                    "Season with salt, pepper, and dill. Serve hot."
                ],
                prepTimeMinutes: 15,
                cookTimeMinutes: 30,
                servings: 4,
                caloriesPerServing: 320,
                proteinPerServing: 15,
                carbsPerServing: 38,
                fatsPerServing: 14,
                dietaryTags: [],
                cuisine: "Latvian",
                difficulty: .easy
            ),
            Recipe(
                id: UUID(uuidString: "A0000000-0000-0000-0000-000000000005")!,
                name: "Fish with Vegetables",
                nameLV: "Zivis ar dārzeņiem",
                description: "Baked fish with roasted vegetables and herbs.",
                ingredients: [
                    RecipeIngredient(ingredientName: "cod", quantity: 400, unit: "g"),
                    RecipeIngredient(ingredientName: "zucchini", quantity: 1, unit: "pcs"),
                    RecipeIngredient(ingredientName: "bell pepper", quantity: 1, unit: "pcs"),
                    RecipeIngredient(ingredientName: "tomatoes", quantity: 2, unit: "pcs"),
                    RecipeIngredient(ingredientName: "onion", quantity: 1, unit: "pcs"),
                    RecipeIngredient(ingredientName: "olive oil", quantity: 2, unit: "tbsp"),
                    RecipeIngredient(ingredientName: "lemon", quantity: 1, unit: "pcs"),
                    RecipeIngredient(ingredientName: "thyme", quantity: 1, unit: "tsp"),
                    RecipeIngredient(ingredientName: "salt", quantity: 1, unit: "tsp"),
                    RecipeIngredient(ingredientName: "black pepper", quantity: 0.5, unit: "tsp")
                ],
                steps: [
                    "Preheat oven to 200°C.",
                    "Cut vegetables into chunks.",
                    "Place vegetables in a baking dish and drizzle with olive oil.",
                    "Season with salt, pepper, and thyme.",
                    "Place fish on top of vegetables.",
                    "Squeeze lemon over the fish.",
                    "Bake for 25-30 minutes until fish is flaky.",
                    "Serve with the roasted vegetables."
                ],
                prepTimeMinutes: 15,
                cookTimeMinutes: 30,
                servings: 2,
                caloriesPerServing: 350,
                proteinPerServing: 35,
                carbsPerServing: 15,
                fatsPerServing: 15,
                dietaryTags: [.glutenFree],
                cuisine: "Mediterranean",
                difficulty: .easy
            )
        ]
    }
}
