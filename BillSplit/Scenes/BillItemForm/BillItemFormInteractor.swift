//  
//  BillItemFormInteractor.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import Foundation

protocol BillItemFormBusinessLogic {
    var itemToEdit: BillExpense? { get }
    func showItemToEdit()
    func createItem(request: BillItemForm.CreateItem.Request)
    func updateItem(request: BillItemForm.UpdateItem.Request)
}

protocol BillItemFormDataStore {
    var itemToEdit: BillExpense? { get }
}

class BillItemFormInteractor: BillItemFormBusinessLogic, BillItemFormDataStore {
    var presenter: BillItemFormPresentationLogic?

    var itemToEdit: BillExpense?
    var worker: ExpensesWorker?

    func showItemToEdit() {
        presenter?.presentItemToEdit(response: .init(itemToEdit: itemToEdit))
    }

    func createItem(request: BillItemForm.CreateItem.Request) {
        worker?.createExpense(
            name: request.fieldValues.itemName,
            price: request.fieldValues.itemPrice,
            assigne: request.fieldValues.itemAssignee,
            quantity: request.fieldValues.itemQuantity
        )
    }

    func updateItem(request: BillItemForm.UpdateItem.Request) {
        guard let itemToEdit = self.itemToEdit else { return }

        worker?.updateExpense(
            id: itemToEdit.id,
            name: request.fieldValues.itemName,
            price: request.fieldValues.itemPrice,
            assigne: request.fieldValues.itemAssignee,
            quantity: request.fieldValues.itemQuantity
        )
    }
}
