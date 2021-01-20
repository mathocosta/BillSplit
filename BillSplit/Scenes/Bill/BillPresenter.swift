//  
//  BillPresenter.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import UIKit

protocol BillPresentationLogic {
    func presentFetchedItems(response: Bill.FetchItems.Response)
}

class BillPresenter: BillPresentationLogic {
    weak var displayDelegate: BillDisplayLogic?

    func presentFetchedItems(response: Bill.FetchItems.Response) {
        var displayedExpenses = [Bill.FetchItems.DisplayedExpense]()

        for expense in response.expenses {
            let displayedExpense = Bill.FetchItems.DisplayedExpense(
                id: expense.id ?? UUID(),
                name: expense.name ?? "",
                price: expense.price,
                assignee: expense.assignee,
                quantity: Int(expense.quantity)
            )

            displayedExpenses.append(displayedExpense)
        }

        displayDelegate?.displayItems(viewModel: .init(displayedExpenses: displayedExpenses))
    }
}
