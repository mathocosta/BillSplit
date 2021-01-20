//  
//  BillItemFormPresenter.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import UIKit

protocol BillItemFormPresentationLogic {
    func presentItemToEdit(response: BillItemForm.EditItem.Response)
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
}
