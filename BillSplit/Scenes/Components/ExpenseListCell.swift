//
//  ExpenseListCell.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

struct ExpenseListCell: View {
    @Environment(\.editMode) var editMode

    let expense: Bill.FetchItems.DisplayedExpense
    let deleteButtonAction: () -> Void

    private func formatPrice(_ value: Double, quantity: Int) -> String {
        let formatter = PriceFormatter()

        return formatter.string(from: NSNumber(value: value * Double(quantity))) ?? ""
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        if expense.quantity > 1 {
                            Text("\(expense.quantity)x")
                                .font(.caption)
                        }

                        Text(expense.name)
                            .font(.headline)
                    }
                } icon: {}

                if let assineeName = expense.assignee {
                    Text(assineeName)
                        .font(.caption)
                }
            }
            Spacer()
            Text(formatPrice(expense.price, quantity: expense.quantity))
                .font(.headline)
            if editMode?.wrappedValue == .active {
                Button(action: deleteButtonAction, label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color(.systemRed))
                })
                .padding(.leading)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color(.systemGray2), radius: 1, x: 0.0, y: 0.0)
    }
}

struct RowView_Previews: PreviewProvider {
    static let testExpense = Bill.FetchItems.DisplayedExpense(
        id: UUID(), name: "Café", price: 12.99, assignee: "Pedro", quantity: 1)

    static var previews: some View {
        ExpenseListCell(expense: testExpense, deleteButtonAction: {})
            .previewLayout(.sizeThatFits)

        ExpenseListCell(expense: testExpense, deleteButtonAction: {})
            .previewLayout(.sizeThatFits)
            .environment(\.editMode, .constant(.active))
    }
}
