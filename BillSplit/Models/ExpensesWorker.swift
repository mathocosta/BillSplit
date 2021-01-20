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

    func createExpense(name: String, price: Float, assigne: String?, quantity: Int) {
        let newExpense = Expense(context: persistenceWorker.managedObjectContext)

        newExpense.id = UUID()
        newExpense.name = name
        newExpense.price = price
        newExpense.assignee = assigne
        newExpense.quantity = Int32(quantity)

        persistenceWorker.saveContext()
    }

    func updateExpense(id: UUID, name: String, price: Float, assigne: String?, quantity: Int) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let expenseToUpdate = persistenceWorker.fetch(request).first else { return }

        expenseToUpdate.name = name
        expenseToUpdate.price = price
        expenseToUpdate.assignee = assigne
        expenseToUpdate.quantity = Int32(quantity)

        persistenceWorker.saveContext()
    }
}
