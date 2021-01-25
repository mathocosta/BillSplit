//  
//  CheckoutInteractor.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 22/01/21.
//

import Foundation

protocol CheckoutBusinessLogic {
    func showCheckout(request: Checkout.Show.Request)
    func makePayment(request: Checkout.Payment.Request)
}

class CheckoutInteractor: CheckoutBusinessLogic {
    var presenter: CheckoutPresentationLogic?
    var worker: CheckoutWorker?

    func showCheckout(request: Checkout.Show.Request) {
        presenter?.presentCheckout(response: Checkout.Show.Response(expenses: request.expenses))
    }

    func makePayment(request: Checkout.Payment.Request) {
        worker?.performPaymentOfExpenses(
            withIds: request.expenses.map(\.id),
            completionHandler: { (error) in
                self.presenter?.presentPaymentResult(
                    response: Checkout.Payment.Response(success: error == nil)
                )
            }
        )
    }
}
