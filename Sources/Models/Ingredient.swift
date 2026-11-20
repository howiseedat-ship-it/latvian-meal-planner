import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let nameLV: String
    let category: String
    let unit: String
    let storePrices: [StorePrice]

    init(
        id: UUID = UUID(),
        name: String,
        nameLV: String,
        category: String,
        unit: String,
        storePrices: [StorePrice] = []
    ) {
        self.id = id
        self.name = name
        self.nameLV = nameLV
        self.category = category
        self.unit = unit
        self.storePrices = storePrices
    }

    var cheapestPrice: Double? {
        storePrices.min(by: { $0.price < $1.price })?.price
    }

    var cheapestStore: String? {
        storePrices.min(by: { $0.price < $1.price })?.store
    }
}

struct StorePrice: Identifiable, Codable, Hashable {
    let id: UUID
    let store: String
    let price: Double
    let currency: String
    let url: String?

    init(
        id: UUID = UUID(),
        store: String,
        price: Double,
        currency: String = "EUR",
        url: String? = nil
    ) {
        self.id = id
        self.store = store
        self.price = price
        self.currency = currency
        self.url = url
    }
}
