//
//  CheckoutView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 18/12/20.
//

import SwiftUI

private struct CheckoutCell: View {
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

    @Environment(\.presentationMode) private var presentationMode
    @State private var isShowingConfirmationAlert = false


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
                    CheckoutCell(label: "Subtotal", value: closedBill.totalValue)
                    CheckoutCell(label: "Taxa de 10%", value: closedBill.serviceTaxValue)
                    CheckoutCell(
                        label: "Total",
                        value: closedBill.totalValue + closedBill.serviceTaxValue
                    )
                    .font(.system(size: 18, weight: .semibold))
                }
                Section(header: Text("Valor por pessoa").bold()) {
                    ForEach(closedBill.totalValueByAssignee.sorted(by: <), id: \.key) {
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
            .alert(isPresented: $isShowingConfirmationAlert,
                   content: confirmationAlert)
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
