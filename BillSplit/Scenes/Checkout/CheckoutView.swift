//
//  CheckoutView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 18/12/20.
//

import SwiftUI

private struct CheckoutCell: View {
    let label: String
    let value: Float

    private func formatPrice(_ value: Float) -> String {
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

class CheckoutStore: ObservableObject {
    let expenses: [BillExpense]

    var subtotalValue: Float {
        expenses.map({ $0.price * Float($0.quantity) }).reduce(0.0, +)
    }

    var serviceTaxValue: Float {
        subtotalValue * 0.1
    }

    var totalValueByAssignee: [String: Float] {
        Dictionary(grouping: expenses, by: { $0.assignee ?? "Not assigned" })
            .mapValues({ $0.map({ $0.price * Float($0.quantity)  }).reduce(0.0, +) })
    }

    init(expenses: [BillExpense]) {
        self.expenses = expenses
    }

    func expensesAssigned(to assigneeName: String) -> [BillExpense] {
        expenses.filter({ $0.assignee == assigneeName })
    }
}

struct CheckoutView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var store: CheckoutStore
    @State private var isShowingConfirmationAlert = false

    init(expenses: [BillExpense]) {
        self.store = CheckoutStore(expenses: expenses)
    }

    private func confirmationAlert() -> Alert {
        Alert(
            title: Text("Atenção"),
            message: Text("Ao confirmar pagamento, os dados serão resetados e não poderá ser desfeito."),
            primaryButton: .destructive(Text("Confirmar"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }),
            secondaryButton: .cancel()
        )
    }

    var body: some View {
            List {
                Section(header: Text("Total").bold()) {
                    CheckoutCell(label: "Subtotal", value: store.subtotalValue)
                    CheckoutCell(label: "Taxa de 10%", value: store.serviceTaxValue)
                    CheckoutCell(
                        label: "Total",
                        value: store.subtotalValue + store.serviceTaxValue
                    )
                    .font(.system(size: 18, weight: .semibold))
                }
                Section(header: Text("Valor por pessoa").bold()) {
                    ForEach(store.totalValueByAssignee.sorted(by: <), id: \.key) {
                        (key, value) in
                        CheckoutCell(label: "\(key) ", value: value)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Conta fechada")
            .navigationBarItems(trailing: Button("Pagar", action: {
                self.isShowingConfirmationAlert = true
            }))
            .alert(isPresented: $isShowingConfirmationAlert, content: confirmationAlert)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView(expenses: [
                BillExpense(name: "Café", price: 12.99, assignee: "Pedro", quantity: 1),
                BillExpense(name: "Banana", price: 3.99, assignee: "Pedro", quantity: 1),
                BillExpense(name: "Café", price: 12.99, assignee: "João", quantity: 1)
            ])
        }
    }
}
