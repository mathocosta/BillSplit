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

private struct ExpenseList: View {
    @ObservedObject var store: BillStore

    @State private var selectedExpense: Bill.FetchItems.DisplayedExpense? = nil
    @State private var isShowingCheckoutView = false

    private var expenses: [Bill.FetchItems.DisplayedExpense] {
        store.displayedExpenses
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(expenses) { (expense) in
                    ExpenseListCell(expense: expense)
                        .onTapGesture {
                            self.selectedExpense = expenses.first(where: {
                                $0.id == expense.id
                            })
                        }
                }

                Spacer(minLength: 16)
                if !expenses.isEmpty {
//                    NavigationLink(
//                        destination: CheckoutView(expenses: expenses),
//                        isActive: $isShowingCheckoutView,
//                        label: { EmptyView() }
//                    )
                    LastCellButton(title: "Fechar conta", action: {
                        self.isShowingCheckoutView = true
                    })
                }

            }
            .padding()
            .sheet(item: $selectedExpense) { _ in
                //BillItemFormView(selectedItem: selectedExpense)
            }
        }
    }
}

// MARK: - Bill view

struct BillView: View {
    @State private var addFormIsPresented = false
    @State private var newExpense: BillExpense?

    @EnvironmentObject var store: BillStore

    var body: some View {
        NavigationView {
            GeometryReader { (geometry) in
                ZStack(alignment: .bottomTrailing) {
                    ExpenseList(store: store)

                    AddItemButton(action: { self.newExpense = BillExpense() })
                        .padding(.trailing)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                        .sheet(item: $newExpense) {
                            print(newExpense.debugDescription)
                        } content: { _ in
                            BillItemFormView()
                        }
                }
                .background(Color(.systemGray6).opacity(0.8))
                .edgesIgnoringSafeArea(.bottom)
                .navigationTitle("Conta aberta")
                .navigationBarItems(trailing: EditButton())
            }
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
    }
}
