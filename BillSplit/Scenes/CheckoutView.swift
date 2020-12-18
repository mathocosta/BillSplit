//
//  CheckoutView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 18/12/20.
//

import SwiftUI

private struct CheckoutRowView: View {
    let label: String
    let value: Double

    private func formatPrice(_ value: Double) -> String {
        PriceFormatter().string(from: NSNumber(value: value)) ?? ""
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(formatPrice(value))
        }
    }
}

struct CheckoutView: View {
    let closedBill: Bill

    var body: some View {
            List {
                Section(header: Text("Total").bold()) {
                    CheckoutRowView(label: "Subtotal", value: closedBill.totalValue)
                    CheckoutRowView(label: "Taxa de 10%", value: closedBill.serviceTaxValue)
                    CheckoutRowView(
                        label: "Total",
                        value: closedBill.totalValue + closedBill.serviceTaxValue
                    )
                    .font(.system(size: 18, weight: .semibold))
                }
                Section(header: Text("Valor por pessoa").bold()) {
                    ForEach(closedBill.totalValueByAssignee.sorted(by: <), id: \.key) {
                        (key, value) in
                        CheckoutRowView(label: "\(key) ", value: value)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Conta fechada")
            .navigationBarItems(trailing: Button("Pagar", action: {}))
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView(closedBill: Bill(expenses: [
                BillExpense(name: "Café", price: 12.99, assignee: "Pedro", quantity: 1),
                BillExpense(name: "Banana", price: 3.99, assignee: "Pedro", quantity: 1),
                BillExpense(name: "Café", price: 12.99, assignee: "João", quantity: 1)
            ]))
        }
    }
}
