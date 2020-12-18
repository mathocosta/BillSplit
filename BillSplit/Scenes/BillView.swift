//
//  BillView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

// MARK: - Components

private struct LastRowButton: View {
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
    var expenses: [BillExpense]

    @State private var selectedExpense: BillExpense? = nil
    @State private var isShowingCheckoutView = false

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(expenses) { (expense) in
                    RowView(expense: expense)
                        .onTapGesture {
                            self.selectedExpense = expenses.first(where: {
                                $0.id == expense.id
                            })
                        }
                }

                Spacer(minLength: 16)
                if !expenses.isEmpty {
                    NavigationLink(
                        destination: CheckoutView(closedBill: Bill(expenses: expenses)),
                        isActive: $isShowingCheckoutView,
                        label: { EmptyView() }
                    )
                    LastRowButton(title: "Fechar conta", action: {
                        self.isShowingCheckoutView = true
                    })
                }

            }
            .padding()
            .sheet(item: $selectedExpense) { _ in
                CreateItemView(expense: $selectedExpense)
            }
        }
    }
}

// MARK: - Bill view

class BillPresenter: ObservableObject {
    @Published var expenses: [BillExpense] = [
        BillExpense(name: "Café", price: 12.99, assignee: nil, quantity: 1),
        BillExpense(name: "Banana", price: 0.50, assignee: "João", quantity: 3)
    ]
}

struct BillView: View {
    @State var addFormIsPresented = false
    @ObservedObject var presenter = BillPresenter()

    @State private var newExpense: BillExpense?

    var body: some View {
        NavigationView {
            GeometryReader { (geometry) in
                ZStack(alignment: .bottomTrailing) {
                    ExpenseList(expenses: presenter.expenses)

                    AddItemButton(action: { self.newExpense = BillExpense() })
                        .padding(.trailing)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                        .sheet(item: $newExpense) {
                            print(newExpense.debugDescription)
                        } content: { _ in
                            CreateItemView(expense: $newExpense)
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
