import SwiftUI

struct RecipeSearchView: View {
    @State private var searchQuery = ""
    @State private var results: [Recipe] = []
    @State private var isSearching = false
    @State private var selectedCuisine: String? = nil
    @State private var selectedDifficulty: Difficulty? = nil
    @State private var maxTime: Int? = nil

    private let cuisines = ["All", "Latvian", "Italian", "Hungarian", "Asian", "Mediterranean", "American", "French", "German", "Polish", "Lithuanian", "Estonian"]
    private let difficulties: [Difficulty] = [.easy, .medium, .hard]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    searchSection
                    filterSection
                    resultsSection
                }
                .padding()
            }
            .navigationTitle("Recipes")
        }
    }

    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search recipes...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit { search() }
        }
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filters")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(cuisines, id: \.self) { cuisine in
                        Button {
                            selectedCuisine = cuisine == "All" ? nil : cuisine
                            search()
                        } label: {
                            Text(cuisine)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedCuisine == cuisine ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedCuisine == cuisine ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
            }

            HStack(spacing: 8) {
                ForEach(difficulties, id: \.self) { difficulty in
                    Button {
                        selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
                        search()
                    } label: {
                        Text(difficulty.rawValue.capitalized)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedDifficulty == difficulty ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedDifficulty == difficulty ? .white : .primary)
                            .cornerRadius(16)
                    }
                }
            }
        }
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isSearching {
                Text("Showing \(results.count) recipes")
                    .font(.headline)

                ForEach(results) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text("Search for recipes or browse by category")
                    .foregroundColor(.secondary)
            }
        }
    }

    private func search() {
        isSearching = true
        if searchQuery.isEmpty {
            results = RecipeService.shared.loadRecipes()
        } else {
            results = RecipeService.shared.searchRecipes(query: searchQuery)
        }

        if let cuisine = selectedCuisine {
            results = results.filter { $0.cuisine == cuisine }
        }
        if let difficulty = selectedDifficulty {
            results = results.filter { $0.difficulty == difficulty }
        }
        if let maxTime = maxTime {
            results = results.filter { $0.totalTimeMinutes <= maxTime }
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.name)
                .font(.headline)
            Text(recipe.nameLV)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Label("\(recipe.totalTimeMinutes) min", systemImage: "clock")
                Label("\(recipe.servings) servings", systemImage: "person.2")
                Label("\(recipe.caloriesPerServing) kcal", systemImage: "flame")
            }
            .font(.caption)
            .foregroundColor(.secondary)

            HStack(spacing: 4) {
                ForEach(recipe.dietaryTags.prefix(3), id: \.self) { tag in
                    Text(tag.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var servings: Int

    init(recipe: Recipe) {
        self.recipe = recipe
        _servings = State(initialValue: recipe.servings)
    }

    var body: some View {
        let scaledRecipe = RecipeService.shared.scaledRecipe(recipe, servings: servings)

        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection(scaledRecipe)
                servingsSection
                ingredientsSection(scaledRecipe)
                stepsSection
                nutritionSection
                equipmentSection
            }
            .padding()
        }
        .navigationTitle(recipe.name)
    }

    private func headerSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.nameLV)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(recipe.description)
                .font(.body)

            HStack(spacing: 12) {
                Label("\(recipe.totalTimeMinutes) min", systemImage: "clock")
                Label("\(recipe.cuisine)", systemImage: "globe")
                Label(recipe.difficulty.rawValue.capitalized, systemImage: "gauge")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }

    private var servingsSection: some View {
        HStack {
            Text("Servings: \(servings)")
                .font(.headline)
            Stepper(value: $servings, in: 1...20) {
                EmptyView()
            }
        }
    }

    private func ingredientsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
            ForEach(recipe.ingredients) { ingredient in
                HStack {
                    Text(ingredient.isOptional ? "○" : "●")
                        .foregroundColor(ingredient.isOptional ? .gray : .blue)
                    Text("\(ingredient.quantity) \(ingredient.unit) \(ingredient.ingredientName)")
                    if ingredient.isOptional {
                        Text("(optional)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Steps")
                .font(.headline)
            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(index + 1).")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text(step)
                }
            }
        }
    }

    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nutrition (per serving)")
                .font(.headline)
            HStack(spacing: 16) {
                NutritionStat(label: "Calories", value: "\(recipe.caloriesPerServing)", unit: "kcal")
                NutritionStat(label: "Protein", value: "\(recipe.proteinPerServing)", unit: "g")
                NutritionStat(label: "Carbs", value: "\(recipe.carbsPerServing)", unit: "g")
                NutritionStat(label: "Fats", value: "\(recipe.fatsPerServing)", unit: "g")
            }
        }
    }

    private var equipmentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Equipment Needed")
                .font(.headline)
            ForEach(recipe.equipment, id: \.self) { equipment in
                Label(equipment.rawValue, systemImage: "wrench")
                    .font(.caption)
            }
        }
    }
}

struct NutritionStat: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value + " " + unit)
                .font(.headline)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    RecipeSearchView()
}
