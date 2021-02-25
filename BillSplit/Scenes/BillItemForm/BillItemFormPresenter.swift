//  
//  BillItemFormPresenter.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import UIKit

protocol BillItemFormPresentationLogic {
    func presentItemToEdit(response: BillItemForm.EditItem.Response)
    func presentCreateItem(response: BillItemForm.CreateItem.Response)
    func presentUpdateItem(response: BillItemForm.UpdateItem.Response)
}

class BillItemFormPresenter: BillItemFormPresentationLogic {
    weak var displayDelegate: BillItemFormDisplayLogic?

    func presentItemToEdit(response: BillItemForm.EditItem.Response) {
        guard let itemToEdit = response.itemToEdit else { return }

        displayDelegate?.displayItemToEdit(
            viewModel: BillItemForm.EditItem.ViewModel(
                name: itemToEdit.name,
                price: itemToEdit.price,
                assignee: itemToEdit.assignee ?? "",
                quantity: itemToEdit.quantity
            )
        )
    }

    private func saveItemViewModel(
        for response: BillItemForm.SaveItem.Response
    ) -> BillItemForm.SaveItem.ViewModel {
        let viewModel: BillItemForm.SaveItem.ViewModel

        if let error = response.error {
            viewModel = BillItemForm.SaveItem.ViewModel(
                success: false, titleText: "Atenção", messageText: error.localizedDescription
            )
        } else {
            viewModel = BillItemForm.SaveItem.ViewModel(success: true)
        }

        return viewModel
    }

    func presentCreateItem(response: BillItemForm.CreateItem.Response) {
        displayDelegate?.displayCreatedItem(viewModel: saveItemViewModel(for: response))
    }

    func presentUpdateItem(response: BillItemForm.UpdateItem.Response) {
        displayDelegate?.displayUpdatedItem(viewModel: saveItemViewModel(for: response))
    }
}
