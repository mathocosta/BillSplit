//
//  BillStore.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import SwiftUI
import CoreData

protocol BillDisplayLogic: AnyObject {
    func displayItems(viewModel: Bill.FetchItems.ViewModel)
}

class BillStore: ObservableObject, BillDisplayLogic {
    var interactor: BillBusinessLogic?

    @Published var displayedExpenses: [Bill.FetchItems.DisplayedExpense] = []

    let persistenceWorker: PersistenceGateway

    init(persistenceWorker: PersistenceGateway) {
        self.persistenceWorker = persistenceWorker
        let presenter = BillPresenter()
        let interactor = BillInteractor()
        interactor.worker = ExpensesWorker(persistenceGateway: persistenceWorker)
        interactor.presenter = presenter
        presenter.displayDelegate = self
        self.interactor = interactor
    }

    func fetchExpenses() {
        interactor?.fetchItems()
    }

    func deleteDisplayedExpense(_ expense: Bill.FetchItems.DisplayedExpense) {
        guard let index = displayedExpenses.firstIndex(where: { $0.id == expense.id })
            else { return }

        interactor?.deleteItem(request: Bill.DeleteItem.Request(index: index))
    }

    func displayItems(viewModel: Bill.FetchItems.ViewModel) {
        self.displayedExpenses = viewModel.displayedExpenses
    }
}
