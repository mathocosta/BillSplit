//
//  Bill.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 18/12/20.
//

import Foundation

struct Bill {
    var expenses: [BillExpense]

    var totalValue: Double {
        expenses.map({ $0.price * Double($0.quantity) }).reduce(0.0, +)
    }

    var serviceTaxValue: Double {
        totalValue * 0.1
    }

    var totalValueByAssignee: [String: Double] {
        Dictionary(grouping: expenses, by: { $0.assignee ?? "Not assigned" })
            .mapValues({ $0.map({ $0.price * Double($0.quantity)  }).reduce(0.0, +) })
    }

    func expensesAssigned(to assigneeName: String) -> [BillExpense] {
        expenses.filter({ $0.assignee == assigneeName })
    }
}
