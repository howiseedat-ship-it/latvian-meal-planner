import Foundation

struct MealPlan: Identifiable, Codable, Hashable {
    let id: UUID
    let weekStart: Date
    let meals: [PlannedMeal]

    init(
        id: UUID = UUID(),
        weekStart: Date,
        meals: [PlannedMeal] = []
    ) {
        self.id = id
        self.weekStart = weekStart
        self.meals = meals
    }
}

struct PlannedMeal: Identifiable, Codable, Hashable {
    let id: UUID
    let day: Weekday
    let mealType: MealType
    let recipeId: UUID
    let servings: Int

    init(
        id: UUID = UUID(),
        day: Weekday,
        mealType: MealType,
        recipeId: UUID,
        servings: Int = 2
    ) {
        self.id = id
        self.day = day
        self.mealType = mealType
        self.recipeId = recipeId
        self.servings = servings
    }
}

enum Weekday: String, Codable, CaseIterable, Hashable, Identifiable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"

    var id: String { rawValue }
}

enum MealType: String, Codable, CaseIterable, Hashable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case snack = "snack"
}
