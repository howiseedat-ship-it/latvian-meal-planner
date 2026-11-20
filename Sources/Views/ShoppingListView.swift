import SwiftUI

struct ShoppingListView: View {
    @State private var shoppingList: ShoppingList?
    @State private var showGenerateSheet = false
    @State private var showDeleteConfirmation = false

    private let shoppingListKey = "saved_shopping_list"

    var body: some View {
        Group {
            if let list = shoppingList {
                ShoppingListContent(
                    list: Binding(
                        get: { shoppingList ?? list },
                        set: { newValue in
                            shoppingList = newValue
                            saveList()
                        }
                    ),
                    onDelete: {
                        showDeleteConfirmation = true
                    },
                    onNewList: {
                        showGenerateSheet = true
                    }
                )
            } else {
                emptyState
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showGenerateSheet) {
            GenerateListSheet { list in
                shoppingList = list
                saveList()
            }
        }
        .confirmationDialog("Удалить список покупок?", isPresented: $showDeleteConfirmation) {
            Button("Удалить", role: .destructive) {
                shoppingList = nil
                UserDefaults.standard.removeObject(forKey: shoppingListKey)
            }
            Button("Отмена", role: .cancel) {}
        }
        .onAppear {
            loadSavedList()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("Нет списка покупок")
                .font(.headline)
            Text("Создайте список из рецептов")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Создать список") {
                showGenerateSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func loadSavedList() {
        if let data = UserDefaults.standard.data(forKey: shoppingListKey),
           let list = try? JSONDecoder().decode(ShoppingList.self, from: data) {
            shoppingList = list
        }
    }

    private func saveList() {
        if let list = shoppingList, let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: shoppingListKey)
        }
    }
}

struct ShoppingListContent: View {
    @Binding var list: ShoppingList
    let onDelete: () -> Void
    let onNewList: () -> Void

    var body: some View {
        List {
            Section {
                ForEach($list.items) { $item in
                    ShoppingItemRow(item: $item)
                }
            }

            Section {
                HStack {
                    Text("Итого")
                        .font(.headline)
                    Spacer()
                    Text(list.totalCost > 0 ? String(format: "€%.2f", list.totalCost) : "—")
                        .font(.headline)
                        .bold()
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Список покупок")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Создать новый", systemImage: "plus") {
                        onNewList()
                    }
                    Button("Удалить", systemImage: "trash", role: .destructive) {
                        onDelete()
                    }
                }
            }
        }
    }
}

struct ShoppingItemRow: View {
    @Binding var item: ShoppingItem

    var body: some View {
        HStack(spacing: 12) {
            Button {
                item.isPurchased.toggle()
            } label: {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isPurchased ? Color.green : Color.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.ingredientName)
                    .font(.body)
                    .strikethrough(item.isPurchased)
                    .foregroundStyle(item.isPurchased ? .secondary : .primary)
                Text("\(formatQuantity(item.quantity)) \(item.unit)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let price = item.price {
                Text(String(format: "€%.2f", price))
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 4)
    }

    private func formatQuantity(_ quantity: Double) -> String {
        if quantity == quantity.rounded() {
            return String(Int(quantity))
        }
        return String(format: "%.1f", quantity)
    }
}

struct GenerateListSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (ShoppingList) -> Void

    @State private var selectedRecipes: Set<UUID> = []
    @State private var recipes: [Recipe] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(recipes) { recipe in
                    HStack {
                        Text(recipe.name)
                        Spacer()
                        if selectedRecipes.contains(recipe.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedRecipes.contains(recipe.id) {
                            selectedRecipes.remove(recipe.id)
                        } else {
                            selectedRecipes.insert(recipe.id)
                        }
                    }
                }
            }
            .navigationTitle("Выберите рецепты")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Создать") {
                        let selected = recipes.filter { selectedRecipes.contains($0.id) }
                        let list = ShoppingListService.shared.generateShoppingList(fromRecipes: selected)
                        onSelect(list)
                        dismiss()
                    }
                    .disabled(selectedRecipes.isEmpty)
                }
            }
            .onAppear {
                recipes = RecipeService.shared.loadRecipes()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShoppingListView()
    }
}
