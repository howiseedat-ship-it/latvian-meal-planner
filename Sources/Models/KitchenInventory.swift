import Foundation

struct KitchenInventory: Identifiable, Codable, Hashable {
    let id: UUID
    let ingredients: [InventoryItem]

    init(
        id: UUID = UUID(),
        ingredients: [InventoryItem] = []
    ) {
        self.id = id
        self.ingredients = ingredients
    }
}

struct InventoryItem: Identifiable, Codable, Hashable {
    let id: UUID
    let ingredientName: String
    let quantity: Double
    let unit: String
    let expiryDate: Date?

    init(
        id: UUID = UUID(),
        ingredientName: String,
        quantity: Double,
        unit: String,
        expiryDate: Date? = nil
    ) {
        self.id = id
        self.ingredientName = ingredientName
        self.quantity = quantity
        self.unit = unit
        self.expiryDate = expiryDate
    }
}
