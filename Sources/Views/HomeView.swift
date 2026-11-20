import SwiftUI

struct HomeView: View {
    @State private var ingredientsInput = ""
    @State private var enteredIngredients: [String] = []
    @State private var matches: [RecipeMatch] = []
    @State private var isSearching = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
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
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What's in your kitchen?")
                .font(.title2)
                .bold()
            Text("Enter ingredients you have and get recipe suggestions")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var ingredientInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TextField("Add ingredient (e.g. chicken, tomato, pasta)", text: $ingredientsInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit { addIngredient() }

                Button("Add") {
                    addIngredient()
                }
                .buttonStyle(.borderedProminent)
                .disabled(ingredientsInput.isEmpty)
            }

            if !enteredIngredients.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(enteredIngredients, id: \.self) { ingredient in
                            HStack(spacing: 4) {
                                Text(ingredient)
                                Button {
                                    enteredIngredients.removeAll { $0 == ingredient }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(16)
                        }
                    }
                }

                Button("Find Recipes") {
                    findRecipes()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Found \(matches.count) recipes")
                .font(.headline)

            ForEach(matches.prefix(10), id: \.recipe.id) { match in
                RecipeMatchCard(match: match)
            }

            if matches.isEmpty {
                Text("No recipes found. Try different ingredients.")
                    .foregroundColor(.secondary)
            }
        }
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)

            QuickActionCard(
                title: "5-Ingredient Recipes",
                icon: "list.bullet",
                color: .green
            )
            QuickActionCard(
                title: "Latvian Cuisine",
                icon: "flag",
                color: .blue
            )
            QuickActionCard(
                title: "Quick Meals (under 30 min)",
                icon: "clock",
                color: .orange
            )
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
                Text("\(Int(match.matchRatio * 100))%")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(match.matchRatio > 0.7 ? .green : .orange)
            }

            Text(match.recipe.nameLV)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Label("\(match.recipe.totalTimeMinutes) min", systemImage: "clock")
                Label("\(match.recipe.servings) servings", systemImage: "person.2")
                Label("\(match.recipe.caloriesPerServing) kcal", systemImage: "flame")
            }
            .font(.caption)
            .foregroundColor(.secondary)

            if !match.missingIngredients.isEmpty {
                Text("Missing: \(match.missingIngredients.map { $0.ingredientName }.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeView()
}
