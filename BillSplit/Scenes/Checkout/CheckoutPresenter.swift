//  
//  CheckoutPresenter.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 22/01/21.
//

import UIKit

protocol CheckoutPresentationLogic {
    func presentCheckout(response: Checkout.Show.Response)
    func presentPaymentResult(response: Checkout.Payment.Response)
}

class CheckoutPresenter: CheckoutPresentationLogic {
    weak var displayDelegate: CheckoutDisplayLogic?

    func presentCheckout(response: Checkout.Show.Response) {
        displayDelegate?.displayCheckout(
            viewModel: Checkout.Show.ViewModel(expenses: response.expenses)
        )
    }

    func presentPaymentResult(response: Checkout.Payment.Response) {
        displayDelegate?.displayPaymentResult(viewModel: Checkout.Payment.ViewModel(titleText: "Sucesso", messageText: "Pagamento efetivado com sucesso!"))
    }
}
