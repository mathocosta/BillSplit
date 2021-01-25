//  
//  BillInteractor.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import Foundation
import CoreData

protocol BillBusinessLogic {
    func fetchItems()
    func deleteItem(request: Bill.DeleteItem.Request)
}

class BillInteractor: NSObject, BillBusinessLogic {
    var presenter: BillPresentationLogic?

    private lazy var fetchResultsController: NSFetchedResultsController<Expense> = {
        guard let controller = self.worker?.makeFetchResultsController() else {
            fatalError("ExpensesWorker is nil")
        }

        controller.delegate = self

        return controller
    }()

    var worker: ExpensesWorker?

    func fetchItems() {
        do {
            try fetchResultsController.performFetch()

            if let fetchedExpenses = fetchResultsController.fetchedObjects {
                let notPaidExpenses = fetchedExpenses.filter({ !$0.isPaid })

                presenter?.presentFetchedItems(
                    response: Bill.FetchItems.Response(expenses: notPaidExpenses)
                )
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteItem(request: Bill.DeleteItem.Request) {
        if let fetchedExpenses = fetchResultsController.fetchedObjects,
           let expenseToDeleteId = fetchedExpenses[request.index].id {
            worker?.deleteExpense(id: expenseToDeleteId)
        }
    }
}

extension BillInteractor: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        if let fetchedExpenses = controller.fetchedObjects as? [Expense] {
            let notPaidExpenses = fetchedExpenses.filter({ !$0.isPaid })

            presenter?.presentFetchedItems(
                response: Bill.FetchItems.Response(expenses: notPaidExpenses)
            )
        }
    }
}
