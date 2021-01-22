//  
//  ExpensesWorker.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 20/01/21.
//

import Foundation
import CoreData

class ExpensesWorker {
    let persistenceWorker: PersistenceWorker

    init(persistenceWorker: PersistenceWorker) {
        self.persistenceWorker = persistenceWorker
    }

    func createExpense(name: String, price: Double, assigne: String?, quantity: Int) {
        persistenceWorker.performBackgroundTask { (context) in
            let newExpense = Expense(context: context)

            newExpense.id = UUID()
            newExpense.name = name
            newExpense.price = price
            newExpense.assignee = assigne
            newExpense.quantity = Int32(quantity)
        }
    }

    func findFirst(id: UUID) -> Expense? {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        return persistenceWorker.fetch(request).first
    }

    func updateExpense(id: UUID, name: String, price: Double, assigne: String?, quantity: Int) {
        guard let expenseToUpdate = findFirst(id: id) else { return }

        persistenceWorker.performBackgroundTask { (context) in
            expenseToUpdate.name = name
            expenseToUpdate.price = price
            expenseToUpdate.assignee = assigne
            expenseToUpdate.quantity = Int32(quantity)
        }
    }

    func deleteExpense(id: UUID) {
        if let expenseToDelete = findFirst(id: id) {
            persistenceWorker.mainContext.perform { [self] in
                persistenceWorker.mainContext.delete(expenseToDelete)
                persistenceWorker.saveContext()
            }
        }
    }

    func makeFetchResultsController() -> NSFetchedResultsController<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        return NSFetchedResultsController<Expense>(
            fetchRequest: fetchRequest,
            managedObjectContext: persistenceWorker.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
}
