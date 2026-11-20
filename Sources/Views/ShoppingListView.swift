import SwiftUI

struct ShoppingListView: View {
    @State private var shoppingList: ShoppingList?
    @State private var showGenerateSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let list = shoppingList {
                        listHeader(list)
                        listItems(list)
                        totalSection(list)
                    } else {
                        emptyState
                    }
                }
                .padding()
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showGenerateSheet = true
                    } label: {
                        Label("Generate", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showGenerateSheet) {
                GenerateListSheet { list in
                    shoppingList = list
                }
            }
        }
    }

    private func listHeader(_ list: ShoppingList) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(list.name)
                .font(.headline)
            Text("\(list.items.count) items")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func listItems(_ list: ShoppingList) -> some View {
        VStack(spacing: 8) {
            ForEach(list.items) { item in
                ShoppingItemRow(item: item)
            }
        }
    }

    private func totalSection(_ list: ShoppingList) -> some View {
        HStack {
            Text("Total")
                .font(.headline)
            Spacer()
            Text(list.totalCost > 0 ? String(format: "€%.2f", list.totalCost) : "—")
                .font(.headline)
                .bold()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            Text("No shopping list yet")
                .font(.headline)
            Text("Generate a list from your meal plan or recipes")
                .foregroundColor(.secondary)

            Button("Generate List") {
                showGenerateSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ShoppingItemRow: View {
    let item: ShoppingItem

    var body: some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(.gray)
            Text(item.ingredientName)
            Spacer()
            Text("\(item.quantity) \(item.unit)")
                .foregroundColor(.secondary)
            if let price = item.price {
                Text(String(format: "€%.2f", price))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct GenerateListSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (ShoppingList) -> Void

    @State private var selectedRecipes: Set<UUID> = []

    var body: some View {
        NavigationView {
            List {
                ForEach(RecipeService.shared.loadRecipes()) { recipe in
                    HStack {
                        Text(recipe.name)
                        Spacer()
                        if selectedRecipes.contains(recipe.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
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
            .navigationTitle("Select Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Generate") {
                        let recipes = RecipeService.shared.loadRecipes().filter { selectedRecipes.contains($0.id) }
                        let list = ShoppingListService.shared.generateShoppingList(fromRecipes: recipes)
                        onSelect(list)
                        dismiss()
                    }
                    .disabled(selectedRecipes.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ShoppingListView()
}
