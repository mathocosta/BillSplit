//
//  BillItemFormView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

protocol BillItemFormDisplayLogic: AnyObject {
    func displayItemToEdit(viewModel: BillItemForm.EditItem.ViewModel)
}

class BillItemFormStore: ObservableObject, BillItemFormDisplayLogic {
    private var interactor: BillItemFormBusinessLogic?

    var itemName = ""
    var itemPrice: Float = 0
    var itemAssignee = ""
    var itemQuantity = 1

    private var fieldValues: BillItemForm.FormFields {
        BillItemForm.FormFields(
            itemName: itemName,
            itemPrice: itemPrice,
            itemAssignee: itemAssignee,
            itemQuantity: itemQuantity
        )
    }

    init(persistenceWorker: PersistenceWorker, itemToEdit: BillExpense?) {
        let presenter = BillItemFormPresenter()
        let interactor = BillItemFormInteractor()
        interactor.worker = ExpensesWorker(persistenceWorker: persistenceWorker)
        interactor.itemToEdit = itemToEdit
        interactor.presenter = presenter
        presenter.displayDelegate = self
        
        self.interactor = interactor
    }

    func showItemToEdit() {
        interactor?.showItemToEdit()
    }

    func displayItemToEdit(viewModel: BillItemForm.EditItem.ViewModel) {
        itemName = viewModel.name
        itemPrice = viewModel.price
        itemAssignee = viewModel.assignee
        itemQuantity = viewModel.quantity
    }

    func onSavePressed() {
        if interactor?.itemToEdit != nil {
            interactor?.updateItem(
                request: BillItemForm.UpdateItem.Request(fieldValues: fieldValues)
            )
        } else {
            interactor?.createItem(
                request: BillItemForm.CreateItem.Request(fieldValues: fieldValues)
            )
        }
    }
}

struct BillItemFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var store: BillItemFormStore

    var disableSaveAction: Bool {
        store.itemName.isEmpty || store.itemPrice < 0
    }

    init(worker: PersistenceWorker, itemToEdit: BillExpense? = nil) {
        self.store = BillItemFormStore(persistenceWorker: worker, itemToEdit: itemToEdit)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome do item", text: $store.itemName)
                TextField("Preço", value: $store.itemPrice, formatter: PriceFormatter())
                    .keyboardType(.decimalPad)
                TextField("Responsável", text: $store.itemAssignee)
                Stepper(value: $store.itemQuantity, in: 1...100) {
                    Text("Quantidade: \(store.itemQuantity)")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Adicionar Item")
            .navigationBarItems(
                trailing: Button("Salvar", action: {
                    self.store.onSavePressed()
                    self.presentationMode.wrappedValue.dismiss()
                })
            )
            .onAppear(perform: store.showItemToEdit)
        }
    }
}

struct BillItemFormView_Previews: PreviewProvider {
    static var previews: some View {
        BillItemFormView(worker: .sharedInstance)

        BillItemFormView(
            worker: .sharedInstance,
            itemToEdit: BillExpense(name: "Café", price: 12.99, assignee: nil, quantity: 1)
        )
    }
}
