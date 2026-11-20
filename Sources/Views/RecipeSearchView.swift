import SwiftUI

struct RecipeSearchView: View {
    @State private var searchQuery = ""
    @State private var results: [Recipe] = []
    @State private var selectedCuisine: String? = nil
    @State private var selectedDifficulty: Difficulty? = nil
    @State private var showFilters = false

    private let cuisines = ["Latvian", "Italian", "Hungarian", "Asian", "Mediterranean", "American", "French", "German", "Polish", "Lithuanian", "Estonian"]

    var body: some View {
        List {
            if results.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "book")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Рецепты не найдены")
                        .font(.headline)
                    Text("Попробуйте изменить запрос или фильтры")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .listRowSeparator(.hidden)
            } else {
                ForEach(results) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        RecipeCard(recipe: recipe)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Рецепты")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchQuery, prompt: "Поиск рецептов...")
        .onChange(of: searchQuery) { _ in
            applyFilters()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Section("Кухня") {
                        Button("Все") {
                            selectedCuisine = nil
                            applyFilters()
                        }
                        ForEach(cuisines, id: \.self) { cuisine in
                            Button(cuisine) {
                                selectedCuisine = cuisine
                                applyFilters()
                            }
                        }
                    }

                    Section("Сложность") {
                        Button("Любая") {
                            selectedDifficulty = nil
                            applyFilters()
                        }
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Button(difficulty.displayName) {
                                selectedDifficulty = difficulty
                                applyFilters()
                            }
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .symbolVariant((selectedCuisine != nil || selectedDifficulty != nil) ? .fill : .none)
                }
            }
        })
        .onAppear {
            applyFilters()
        }
    }

    private func applyFilters() {
        var filtered = RecipeService.shared.loadRecipes()

        if !searchQuery.isEmpty {
            filtered = RecipeService.shared.searchRecipes(query: searchQuery)
        }

        if let cuisine = selectedCuisine {
            filtered = filtered.filter { $0.cuisine == cuisine }
        }

        if let difficulty = selectedDifficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }

        results = filtered
    }
}

extension Difficulty {
    var displayName: String {
        switch self {
        case .easy: return "Лёгкий"
        case .medium: return "Средний"
        case .hard: return "Сложный"
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
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Label("\(recipe.totalTimeMinutes) мин", systemImage: "clock")
                Label("\(recipe.servings) порц.", systemImage: "person.2")
                Label("\(recipe.caloriesPerServing) ккал", systemImage: "flame")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if !recipe.dietaryTags.isEmpty {
                HStack(spacing: 4) {
                    ForEach(recipe.dietaryTags.prefix(3), id: \.self) { tag in
                        Text(tag.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
            VStack(alignment: .leading, spacing: 20) {
                headerSection(scaledRecipe)
                servingsSection
                ingredientsSection(scaledRecipe)
                stepsSection
                nutritionSection
                if !recipe.equipment.isEmpty {
                    equipmentSection
                }
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }

    private func headerSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.nameLV)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(recipe.description)
                .font(.body)

            HStack(spacing: 16) {
                Label("\(recipe.totalTimeMinutes) мин", systemImage: "clock")
                Label(recipe.cuisine, systemImage: "globe")
                Label(recipe.difficulty.displayName, systemImage: "gauge")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var servingsSection: some View {
        HStack {
            Label("Порции: \(servings)", systemImage: "person.2")
                .font(.headline)
            Spacer()
            Stepper(value: $servings, in: 1...20, step: 1) {
                EmptyView()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func ingredientsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ингредиенты")
                .font(.headline)

            ForEach(recipe.ingredients) { ingredient in
                HStack(spacing: 8) {
                    Image(systemName: ingredient.isOptional ? "circle" : "circle.fill")
                        .font(.caption2)
                        .foregroundStyle(ingredient.isOptional ? Color.secondary : Color.blue)
                    Text("\(formatQuantity(ingredient.quantity)) \(ingredient.unit) — \(ingredient.ingredientName)")
                        .font(.subheadline)
                    if ingredient.isOptional {
                        Text("(по желанию)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Приготовление")
                .font(.headline)

            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.blue)
                        .clipShape(Circle())
                    Text(step)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Питательная ценность (на порцию)")
                .font(.headline)

            HStack(spacing: 8) {
                NutritionStat(label: "Калории", value: "\(recipe.caloriesPerServing)", unit: "ккал")
                NutritionStat(label: "Белки", value: String(format: "%.0f", recipe.proteinPerServing), unit: "г")
                NutritionStat(label: "Углеводы", value: String(format: "%.0f", recipe.carbsPerServing), unit: "г")
                NutritionStat(label: "Жиры", value: String(format: "%.0f", recipe.fatsPerServing), unit: "г")
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var equipmentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Посуда и оборудование")
                .font(.headline)

            HStack(spacing: 6) {
                ForEach(recipe.equipment, id: \.self) { equipment in
                    Label(equipment.rawValue, systemImage: "wrench")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func formatQuantity(_ quantity: Double) -> String {
        if quantity == quantity.rounded() {
            return String(Int(quantity))
        }
        return String(format: "%.1f", quantity)
    }
}

struct NutritionStat: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value) \(unit)")
                .font(.subheadline)
                .bold()
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        RecipeSearchView()
    }
}
