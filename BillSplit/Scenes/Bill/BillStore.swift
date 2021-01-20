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

    init(managedObjectContext: NSManagedObjectContext) {
        let presenter = BillPresenter()
        let interactor = BillInteractor(managedObjectContext: managedObjectContext)
        interactor.presenter = presenter
        presenter.displayDelegate = self
        self.interactor = interactor
    }

    func fetchExpenses() {
        interactor?.fetchItems()
    }

    func displayItems(viewModel: Bill.FetchItems.ViewModel) {
        self.displayedExpenses = viewModel.displayedExpenses
    }
}
