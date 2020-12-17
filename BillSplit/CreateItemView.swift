//
//  CreateItemView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

struct CreateItemView: View {
    @State private var itemName = ""
    @State private var itemPrice: Double = 0
    @State private var itemAssignee = ""
    @State private var itemQuantity = 1

    @Binding var isPresented: Bool

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        return formatter
    }()

    private var disableSaveAction: Bool {
        itemName.isEmpty && itemPrice < 0
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome do item", text: $itemName)
                TextField("Preço", value: $itemPrice, formatter: currencyFormatter)
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
                    self.isPresented = false
                }).disabled(disableSaveAction)
            )
        }
    }
}

struct CreateItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreateItemView(isPresented: .constant(true))
    }
}
