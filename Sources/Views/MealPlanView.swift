import SwiftUI

struct MealPlanView: View {
    @State private var currentWeekStart: Date = Date()
    @State private var mealPlan: MealPlan?
    @State private var showAddMeal = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    weekHeader
                    if let plan = mealPlan {
                        planSection(plan)
                    } else {
                        createPlanSection
                    }
                }
                .padding()
            }
            .navigationTitle("Meal Plan")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        generatePlan()
                    } label: {
                        Label("Generate", systemImage: "sparkles")
                    }
                }
            }
        }
    }

    private var weekHeader: some View {
        HStack {
            Button {
                shiftWeek(by: -7)
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(currentWeekStart, format: .dateTime.month(.abbreviated).day())
                .font(.headline)

            Spacer()

            Button {
                shiftWeek(by: 7)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }

    private var createPlanSection: some View {
        VStack(spacing: 16) {
            Text("Create a weekly meal plan")
                .font(.headline)
            Text("Tap 'Generate' to get a suggested plan based on available recipes")
                .foregroundColor(.secondary)

            Button("Generate Plan") {
                generatePlan()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }

    private func planSection(_ plan: MealPlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Weekday.allCases) { day in
                DayPlanCard(
                    day: day,
                    meals: plan.meals.filter { $0.day == day }
                )
            }
        }
    }

    private func generatePlan() {
        let recipes = RecipeService.shared.loadRecipes()
        guard !recipes.isEmpty else { return }

        var meals: [PlannedMeal] = []
        let mealTypes: [MealType] = [.breakfast, .lunch, .dinner]

        for day in Weekday.allCases {
            for mealType in mealTypes {
                let randomRecipe = recipes.randomElement()
                if let recipe = randomRecipe {
                    meals.append(PlannedMeal(
                        day: day,
                        mealType: mealType,
                        recipeId: recipe.id,
                        servings: 2
                    ))
                }
            }
        }

        mealPlan = MealPlan(weekStart: currentWeekStart, meals: meals)
    }

    private func shiftWeek(by days: Int) {
        let calendar = Calendar.current
        if let newWeekStart = calendar.date(byAdding: .day, value: days, to: currentWeekStart) {
            currentWeekStart = newWeekStart
            mealPlan = nil
        }
    }
}

struct DayPlanCard: View {
    let day: Weekday
    let meals: [PlannedMeal]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(day.rawValue.capitalized)
                .font(.headline)

            if meals.isEmpty {
                Text("No meals planned")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(meals) { meal in
                    HStack {
                        Text(meal.mealType.rawValue.capitalized)
                            .font(.subheadline)
                            .bold()
                            .frame(width: 80, alignment: .leading)
                        Text("Recipe \(meal.recipeId.uuidString.prefix(8))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(meal.servings) servings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    MealPlanView()
}
