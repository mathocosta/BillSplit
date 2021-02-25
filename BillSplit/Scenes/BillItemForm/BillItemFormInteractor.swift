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

    private func validate(formFields: BillItemForm.FormFields) throws {
        guard !formFields.itemName.isEmpty else {
            throw BillItemForm.SavingError.missingName
        }

        guard formFields.itemPrice > 0 else {
            throw BillItemForm.SavingError.invalidPrice
        }
    }

    func createItem(request: BillItemForm.CreateItem.Request) {
        do {
            try validate(formFields: request.fieldValues)

            worker?.createExpense(
                name: request.fieldValues.itemName,
                price: request.fieldValues.itemPrice,
                assigne: request.fieldValues.itemAssignee,
                quantity: request.fieldValues.itemQuantity
            )

            presenter?.presentCreateItem(response: BillItemForm.CreateItem.Response(success: true))
        } catch {
            presenter?.presentCreateItem(
                response: BillItemForm.CreateItem.Response(success: false, error: error)
            )
        }
    }

    func updateItem(request: BillItemForm.UpdateItem.Request) {
        do {
            guard let itemToEdit = self.itemToEdit
                else { throw BillItemForm.SavingError.undefined }

            try validate(formFields: request.fieldValues)

            worker?.updateExpense(
                id: itemToEdit.id,
                name: request.fieldValues.itemName,
                price: request.fieldValues.itemPrice,
                assigne: request.fieldValues.itemAssignee,
                quantity: request.fieldValues.itemQuantity
            )

            presenter?.presentUpdateItem(response: BillItemForm.UpdateItem.Response(success: true))
        } catch {
            presenter?.presentCreateItem(response: BillItemForm.CreateItem.Response(success: false, error: error))
        }
    }
}
