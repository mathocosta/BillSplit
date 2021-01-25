//
//  CheckoutView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 18/12/20.
//

import SwiftUI

private struct CheckoutCell: View {
    let label: String
    let value: Double

    private func formatPrice(_ value: Double) -> String {
        PriceFormatter().string(from: NSNumber(value: value)) ?? ""
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(formatPrice(value))
        }
    }
}

protocol CheckoutDisplayLogic: AnyObject {
    func displayCheckout(viewModel: Checkout.Show.ViewModel)
    func displayPaymentResult(viewModel: Checkout.Payment.ViewModel)
}

class CheckoutStore: ObservableObject, CheckoutDisplayLogic {
    enum ActiveAlert: Int, Identifiable {
        case confirmPayment, paymentResult

        var id: Int {
            return rawValue
        }
    }

    @Published var viewModel: Checkout.Show.ViewModel?
    @Published var activeAlert: ActiveAlert?

    private var expenses: [BillExpense]
    var alertViewModel: Checkout.Payment.ViewModel?
    var interactor: CheckoutBusinessLogic?

    var subtotalValue: Double {
        viewModel?.subtotalValue ?? 0
    }

    var serviceTaxValue: Double {
        viewModel?.serviceTaxValue ?? 0
    }

    var totalValueByAssignee: [String: Double] {
        viewModel?.totalValueByAssignee ?? [:]
    }

    init(expenses: [BillExpense], persistenceWorker: PersistenceWorker) {
        self.expenses = expenses

        let presenter = CheckoutPresenter()
        let interactor = CheckoutInteractor()
        interactor.worker = CheckoutWorker(persistenceWorker: persistenceWorker)
        interactor.presenter = presenter
        presenter.displayDelegate = self

        self.interactor = interactor
    }

    func showCheckout() {
        interactor?.showCheckout(request: .init(expenses: self.expenses))
    }

    func makePayment() {
        interactor?.makePayment(request: .init(expenses: self.expenses))
    }

    func displayCheckout(viewModel: Checkout.Show.ViewModel) {
        self.viewModel = viewModel
    }

    func displayPaymentResult(viewModel: Checkout.Payment.ViewModel) {
        self.alertViewModel = viewModel
        self.activeAlert = .paymentResult
    }
}

struct CheckoutView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var store: CheckoutStore
    @State private var isShowingConfirmationAlert = false

    init(expenses: [BillExpense], persistenceWorker: PersistenceWorker) {
        self.store = CheckoutStore(expenses: expenses, persistenceWorker: persistenceWorker)
    }

    private var paymentResultAlert: Alert {
        Alert(
            title: Text(store.alertViewModel!.titleText),
            message: Text(store.alertViewModel!.messageText),
            dismissButton: .default(Text("Ok"), action: {
                self.presentationMode.wrappedValue.dismiss()
            })
        )
    }

    private var confirmationAlert: Alert {
        Alert(
            title: Text("Atenção"),
            message: Text("Ao confirmar pagamento, os dados serão resetados e não poderá ser desfeito."),
            primaryButton: .destructive(Text("Confirmar"), action: {
                self.store.makePayment()
            }),
            secondaryButton: .cancel()
        )
    }

    var body: some View {
            List {
                Section(header: Text("Total").bold()) {
                    CheckoutCell(label: "Subtotal", value: store.subtotalValue)
                    CheckoutCell(label: "Taxa de 10%", value: store.serviceTaxValue)
                    CheckoutCell(
                        label: "Total",
                        value: store.subtotalValue + store.serviceTaxValue
                    )
                    .font(.system(size: 18, weight: .semibold))
                }
                Section(header: Text("Valor por pessoa").bold()) {
                    ForEach(store.totalValueByAssignee.sorted(by: <), id: \.key) {
                        (key, value) in
                        CheckoutCell(label: "\(key) ", value: value)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Conta fechada")
            .navigationBarItems(trailing: Button("Pagar", action: {
                self.store.activeAlert = .confirmPayment
            }))
            .alert(item: $store.activeAlert, content: { (alert) in
                switch alert {
                case .confirmPayment:
                    return confirmationAlert
                case .paymentResult:
                    return paymentResultAlert
                }
            })
            .onAppear(perform: store.showCheckout)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView(expenses: [
                BillExpense(name: "Café", price: 12.99, assignee: "Pedro", quantity: 1),
                BillExpense(name: "Banana", price: 3.99, assignee: "Pedro", quantity: 1),
                BillExpense(name: "Café", price: 12.99, assignee: "João", quantity: 1)
            ], persistenceWorker: .sharedInstance)
        }
    }
}
