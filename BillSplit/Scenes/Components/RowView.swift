//
//  RowView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

struct RowView: View {
    @Environment(\.editMode) var editMode

    let expense: BillExpense

    private func formatPrice(_ value: Double, quantity: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

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
            if editMode?.wrappedValue == .active {
                Button(action: {}, label: {
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
    }
}

struct RowView_Previews: PreviewProvider {
    static let testExpense = BillExpense(name: "Café", price: 12.99, assignee: "Pedro", quantity: 1)

    static var previews: some View {
        RowView(expense: testExpense)
            .previewLayout(.sizeThatFits)

        RowView(expense: testExpense)
            .previewLayout(.sizeThatFits)
            .environment(\.editMode, .constant(.active))
    }
}
