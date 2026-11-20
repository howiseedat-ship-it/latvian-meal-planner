import SwiftUI

struct HomeView: View {
    @State private var ingredientsInput = ""
    @State private var enteredIngredients: [String] = []
    @State private var matches: [RecipeMatch] = []
    @State private var isSearching = false
    @State private var showClearConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                ingredientInputSection

                if isSearching {
                    searchResultsSection
                } else {
                    quickActionsSection
                }
            }
            .padding()
        }
        .navigationTitle("Latvian Meal Planner")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Что в вашей кухне?")
                .font(.title2)
                .bold()
            Text("Введите ингредиенты и получите рекомендации")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var ingredientInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                TextField("Добавить ингредиент (курица, томат...)", text: $ingredientsInput)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .onSubmit { addIngredient() }

                Button {
                    addIngredient()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .disabled(ingredientsInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            if !enteredIngredients.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(enteredIngredients, id: \.self) { ingredient in
                            HStack(spacing: 4) {
                                Text(ingredient)
                                    .font(.subheadline)
                                Button {
                                    enteredIngredients.removeAll { $0 == ingredient }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.12))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 4)
                }

                Button {
                    findRecipes()
                } label: {
                    Label("Найти рецепты", systemImage: "magnifyingglass")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Найдено: \(matches.count)")
                    .font(.headline)
                Spacer()
                Button("Сбросить") {
                    isSearching = false
                    matches = []
                    enteredIngredients = []
                }
                .font(.subheadline)
            }

            if matches.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Ничего не найдено")
                        .font(.headline)
                    Text("Попробуйте другие ингредиенты")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(matches.prefix(10), id: \.recipe.id) { match in
                    NavigationLink {
                        RecipeDetailView(recipe: match.recipe)
                    } label: {
                        RecipeMatchCard(match: match)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Быстрые действия")
                .font(.headline)

            VStack(spacing: 8) {
                QuickActionCard(
                    title: "Рецепты из 5 ингредиентов",
                    icon: "list.bullet",
                    color: .green
                ) {
                    isSearching = true
                    matches = RecipeService.shared.fiveIngredientRecipes()
                        .map { RecipeMatch(recipe: $0, matchCount: 0, totalIngredients: 0, matchRatio: 1.0, missingIngredients: []) }
                }

                QuickActionCard(
                    title: "Латвийская кухня",
                    icon: "flag",
                    color: .blue
                ) {
                    isSearching = true
                    matches = RecipeService.shared.loadRecipes()
                        .filter { $0.cuisine == "Latvian" }
                        .map { RecipeMatch(recipe: $0, matchCount: 0, totalIngredients: 0, matchRatio: 1.0, missingIngredients: []) }
                }

                QuickActionCard(
                    title: "Быстрые блюда (до 30 мин)",
                    icon: "clock",
                    color: .orange
                ) {
                    isSearching = true
                    matches = RecipeService.shared.loadRecipes()
                        .filter { $0.totalTimeMinutes <= 30 }
                        .map { RecipeMatch(recipe: $0, matchCount: 0, totalIngredients: 0, matchRatio: 1.0, missingIngredients: []) }
                }
            }
        }
    }

    private func addIngredient() {
        let ingredient = ingredientsInput.trimmingCharacters(in: .whitespaces).lowercased()
        guard !ingredient.isEmpty else { return }
        if !enteredIngredients.contains(ingredient) {
            enteredIngredients.append(ingredient)
        }
        ingredientsInput = ""
    }

    private func findRecipes() {
        isSearching = true
        matches = RecipeService.shared.recipes(forIngredients: enteredIngredients)
    }
}

struct RecipeMatchCard: View {
    let match: RecipeMatch

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(match.recipe.name)
                    .font(.headline)
                Spacer()
                if match.totalIngredients > 0 {
                    Text("\(Int(match.matchRatio * 100))%")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(match.matchRatio > 0.7 ? .green : .orange)
                }
            }

            Text(match.recipe.nameLV)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Label("\(match.recipe.totalTimeMinutes) мин", systemImage: "clock")
                Label("\(match.recipe.servings) порц.", systemImage: "person.2")
                Label("\(match.recipe.caloriesPerServing) ккал", systemImage: "flame")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if !match.missingIngredients.isEmpty {
                Text("Не хватает: \(match.missingIngredients.map { $0.ingredientName }.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                    .frame(width: 40)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
