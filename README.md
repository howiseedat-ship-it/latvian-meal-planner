# Latvian Meal Planner

iOS meal planner app for Latvia, modeled after MiSe (com.gregorytaylor.shopping).

## Features

- **Ingredient-based recipe suggestions**: Enter what you have in your kitchen (e.g., "chicken mince, red pepper, tomatoes, pasta") and get recipe matches with missing ingredients highlighted
- **Weekly meal planning**: Generate and manage weekly meal plans
- **Shopping lists**: Auto-generated from meal plans or selected recipes
- **Kitchen equipment**: Recipes show required equipment
- **Nutritional stats**: Calories, protein, carbs, fats per serving
- **Multi-language**: English and Latvian
- **Serving size scaling**: Adjust portions for any number of people
- **5-ingredient recipes**: Quick meal suggestions
- **Works completely free**: No API costs, no subscriptions, all data local

## Project Structure

```
Sources/
├── LatvianMealPlannerApp.swift    # Main app entry point
├── Models/
│   ├── Recipe.swift               # Recipe model with equipment
│   ├── Ingredient.swift           # Ingredient with store prices
│   ├── MealPlan.swift             # Weekly meal plan
│   ├── ShoppingList.swift         # Shopping list
│   └── KitchenInventory.swift     # Kitchen inventory
├── Views/
│   ├── HomeView.swift             # Ingredient-based search
│   ├── RecipeSearchView.swift     # Recipe browser
│   ├── MealPlanView.swift         # Weekly plan
│   └── ShoppingListView.swift     # Shopping lists
├── Services/
│   ├── RecipeService.swift        # Recipe loading and matching
│   └── ShoppingListService.swift  # Shopping list generation
└── Data/
    ├── RecipeDatabase.swift       # Fallback recipe database
    └── recipes.json               # JSON recipe database (15 recipes)
```

## Building

1. Open Xcode on macOS
2. Create a new iOS App project (SwiftUI, iOS 16+)
3. Add all files from `Sources/` to the project
4. Make sure `recipes.json` is included in the bundle
5. Build and run

## Adding Recipes

### Local (bundled)
Edit `Sources/Data/recipes.json` or run `python scripts/generate_recipes.py` to regenerate.

### Auto-update (GitHub)
The app fetches recipes from GitHub at runtime (checks every 24 hours):
1. Push `recipes.json` to a GitHub repo (e.g., `yourusername/latvian-meal-planner-recipes`)
2. Update the URL in `Sources/Services/RecipeUpdateService.swift`
3. App downloads and caches new recipes automatically — no rebuild needed

Each recipe needs:
- Unique UUID for `id`
- `name` (English) and `nameLV` (Latvian)
- `ingredients` array with name, quantity, unit
- `steps` array
- `equipment` array (from KitchenEquipment enum)
- Nutrition info (calories, protein, carbs, fats)

## CI/CD

### GitHub Actions
`.github/workflows/build.yml` — builds unsigned IPA on push to main or manually.
Validates recipes JSON before building.

### Codemagic
`codemagic.yaml` — builds unsigned IPA on Mac Mini M2.
Set up at https://codemagic.io/ and connect the repo.

## Integration with RigaAtlaides

To add Latvian store prices (Rimi, Maxima, Lidl, top!, Mego), integrate with the RigaAtlaides project at `E:\youtubeapp\RigaAtlaides`. The `Ingredient` model already has a `storePrices` field for this purpose.
