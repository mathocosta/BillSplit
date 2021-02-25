//
//  BillView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

// MARK: - Components

private struct LastCellButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                Spacer()
            }
        }
        .buttonStyle(RoundedButtonStyle())
    }
}

private struct AddItemButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .font(.headline)
                Text("Adicionar")
                    .font(.headline)
            }
        }
        .buttonStyle(RoundedButtonStyle(cornerRadius: 25))
    }
}

// TODO: Move this function to a proper file
private func makeBillExpenses(
    from displayedExpenses: [Bill.FetchItems.DisplayedExpense]
) -> [BillExpense] {
    displayedExpenses.map({
        BillExpense(
            id: $0.id,
            name: $0.name,
            price: $0.price,
            assignee: $0.assignee,
            quantity: $0.quantity
        )
    })
}

private struct ExpenseList: View {
    @ObservedObject var store: BillStore

    @State private var isShowingCheckoutView = false

    var onCellTapped: (Bill.FetchItems.DisplayedExpense) -> Void
    var onDeleteTapped: (Bill.FetchItems.DisplayedExpense) -> Void

    private var expenses: [Bill.FetchItems.DisplayedExpense] {
        store.displayedExpenses
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(expenses) { (expense) in
                    ExpenseListCell(
                        expense: expense,
                        deleteButtonAction: { self.onDeleteTapped(expense) }
                    ).onTapGesture { self.onCellTapped(expense) }
                }

                Spacer(minLength: 16)
                if !expenses.isEmpty {
                    NavigationLink(
                        destination: CheckoutView(
                            expenses: makeBillExpenses(from: expenses),
                            persistenceWorker: store.persistenceWorker
                        ),
                        isActive: $isShowingCheckoutView,
                        label: { EmptyView() }
                    )
                    LastCellButton(title: "Fechar conta", action: {
                        self.isShowingCheckoutView = true
                    })
                }

            }
            .padding()
        }
    }
}

// MARK: - Bill view

struct BillView: View {
    @State private var addFormIsPresented = false
    @State private var newExpense: BillExpense?

    private var persistenceWorker: PersistenceGateway

    @ObservedObject var store: BillStore

    init(persistenceWorker: PersistenceGateway) {
        self.persistenceWorker = persistenceWorker
        self.store = BillStore(persistenceWorker: persistenceWorker)
    }

    private func cellTappedAction(_ target: Bill.FetchItems.DisplayedExpense) {
        newExpense = BillExpense(
            id: target.id,
            name: target.name,
            price: target.price,
            assignee: target.assignee,
            quantity: target.quantity
        )
    }

    private func deleteCellAction(_ target: Bill.FetchItems.DisplayedExpense) {
        store.deleteDisplayedExpense(target)
    }

    var body: some View {
        NavigationView {
            GeometryReader { (geometry) in
                ZStack(alignment: .bottomTrailing) {
                    ExpenseList(
                        store: store,
                        onCellTapped: cellTappedAction(_:),
                        onDeleteTapped: deleteCellAction(_:)
                    ).onAppear(perform: self.store.fetchExpenses)

                    AddItemButton(action: { self.newExpense = BillExpense() })
                        .padding(.trailing)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                }
                .background(Color(.systemGray6).opacity(0.8))
                .edgesIgnoringSafeArea(.bottom)
                .navigationTitle("Conta aberta")
                .navigationBarItems(trailing: EditButton())
                .sheet(item: $newExpense) {
                    print(newExpense.debugDescription)
                } content: { (item) in
                    BillItemFormView(worker: persistenceWorker, itemToEdit: item)
                }
            }
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView(persistenceWorker: .sharedInstance)
    }
}
