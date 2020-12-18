//
//  CreateItemView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

struct CreateItemView: View {
    @Environment(\.presentationMode) var presentation

    @State private var itemName = ""
    @State private var itemPrice: Double = 0
    @State private var itemAssignee = ""
    @State private var itemQuantity = 1

    @Binding var expense: BillExpense?

    private var disableSaveAction: Bool {
        itemName.isEmpty || itemPrice < 0
    }

    private func updateDataIfNeeded() {
        guard let expense = self.expense else { return }

        itemName = expense.name
        itemPrice = expense.price
        itemAssignee = expense.assignee ?? ""
        itemQuantity = expense.quantity
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome do item", text: $itemName)
                TextField("Preço", value: $itemPrice, formatter: PriceFormatter())
                    .keyboardType(.decimalPad)
                TextField("Responsável", text: $itemAssignee)
                Stepper(value: $itemQuantity, in: 1...100) {
                    Text("Quantidade: \(itemQuantity)")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Adicionar Item")
            .navigationBarItems(
                trailing: Button("Salvar", action: {
                    self.presentation.wrappedValue.dismiss()
                }).disabled(disableSaveAction)
            )
            .onAppear(perform: self.updateDataIfNeeded)
        }
    }
}

struct CreateItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreateItemView(expense: .constant(nil))

        CreateItemView(
            expense: .constant(
                BillExpense(name: "Café", price: 12.99, assignee: "Pedro", quantity: 1)
            )
        )
    }
}
