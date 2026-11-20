import Foundation

struct ShoppingList: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let items: [ShoppingItem]
    let createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        items: [ShoppingItem] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.items = items
        self.createdAt = createdAt
    }

    var totalCost: Double {
        items.reduce(0) { $0 + $1.estimatedCost }
    }
}

struct ShoppingItem: Identifiable, Codable, Hashable {
    let id: UUID
    let ingredientName: String
    let quantity: Double
    let unit: String
    let store: String?
    let price: Double?
    let isPurchased: Bool
    let sourceRecipeId: UUID?

    init(
        id: UUID = UUID(),
        ingredientName: String,
        quantity: Double,
        unit: String,
        store: String? = nil,
        price: Double? = nil,
        isPurchased: Bool = false,
        sourceRecipeId: UUID? = nil
    ) {
        self.id = id
        self.ingredientName = ingredientName
        self.quantity = quantity
        self.unit = unit
        self.store = store
        self.price = price
        self.isPurchased = isPurchased
        self.sourceRecipeId = sourceRecipeId
    }

    var estimatedCost: Double {
        price ?? 0
    }
}
