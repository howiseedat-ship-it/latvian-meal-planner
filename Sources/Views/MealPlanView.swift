import SwiftUI

struct MealPlanView: View {
    @State private var currentWeekStart: Date = Date()
    @State private var mealPlan: MealPlan?
    @State private var showDeleteConfirmation = false

    private let mealPlanKey = "saved_meal_plan"

    var body: some View {
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
        .navigationTitle("План питания")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            if mealPlan != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Сгенерировать заново", systemImage: "arrow.clockwise") {
                            generatePlan()
                        }
                        Button("Удалить план", systemImage: "trash", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    }
                }
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        generatePlan()
                    } label: {
                        Label("Создать", systemImage: "sparkles")
                    }
                }
            }
        }
        .confirmationDialog("Удалить план питания?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Удалить", role: .destructive) {
                mealPlan = nil
                UserDefaults.standard.removeObject(forKey: mealPlanKey)
            }
            Button("Отмена", role: .cancel) {}
        }
        .onAppear {
            loadSavedPlan()
        }
    }

    private func loadSavedPlan() {
        if let data = UserDefaults.standard.data(forKey: mealPlanKey),
           let plan = try? JSONDecoder().decode(MealPlan.self, from: data) {
            mealPlan = plan
        }
    }

    private func savePlan() {
        if let plan = mealPlan, let data = try? JSONEncoder().encode(plan) {
            UserDefaults.standard.set(data, forKey: mealPlanKey)
        }
    }

    private var weekHeader: some View {
        HStack {
            Button {
                shiftWeek(by: -7)
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
            }

            Spacer()

            Text(weekRangeText)
                .font(.headline)

            Spacer()

            Button {
                shiftWeek(by: 7)
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
            }
        }
        .padding(.horizontal, 8)
    }

    private var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        let calendar = Calendar.current
        if let weekEnd = calendar.date(byAdding: .day, value: 6, to: currentWeekStart) {
            return "\(formatter.string(from: currentWeekStart)) — \(formatter.string(from: weekEnd))"
        }
        return formatter.string(from: currentWeekStart)
    }

    private var createPlanSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("Создайте план питания")
                .font(.headline)
            Text("Нажмите «Создать», чтобы получить план на неделю на основе доступных рецептов")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Создать план") {
                generatePlan()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
        savePlan()
    }

    private func shiftWeek(by days: Int) {
        let calendar = Calendar.current
        if let newWeekStart = calendar.date(byAdding: .day, value: days, to: currentWeekStart) {
            currentWeekStart = newWeekStart
            mealPlan = nil
            loadSavedPlan()
        }
    }
}

struct DayPlanCard: View {
    let day: Weekday
    let meals: [PlannedMeal]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(day.displayName)
                .font(.headline)

            if meals.isEmpty {
                Text("Нет запланированных блюд")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(meals) { meal in
                    HStack {
                        Text(meal.mealType.displayName)
                            .font(.subheadline)
                            .bold()
                            .frame(width: 90, alignment: .leading)

                        if let recipe = RecipeService.shared.loadRecipes().first(where: { $0.id == meal.recipeId }) {
                            Text(recipe.name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        } else {
                            Text("Рецепт не найден")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("\(meal.servings) порц.")
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
}

extension Weekday {
    var displayName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
}

extension MealType {
    var displayName: String {
        switch self {
        case .breakfast: return "Завтрак"
        case .lunch: return "Обед"
        case .dinner: return "Ужин"
        case .snack: return "Перекус"
        }
    }
}

#Preview {
    NavigationStack {
        MealPlanView()
    }
}
