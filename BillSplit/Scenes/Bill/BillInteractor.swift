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
}

protocol BillDataStore {
}

class BillInteractor: BillBusinessLogic, BillDataStore {
    var presenter: BillPresentationLogic?

    private let fetchResultsController: NSFetchedResultsController<Expense>

    init(managedObjectContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        self.fetchResultsController = NSFetchedResultsController<Expense>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    func fetchItems() {
        do {
            try fetchResultsController.performFetch()

            if let fetchedExpenses = fetchResultsController.fetchedObjects {
                presenter?.presentFetchedItems(
                    response: Bill.FetchItems.Response(expenses: fetchedExpenses)
                )
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
