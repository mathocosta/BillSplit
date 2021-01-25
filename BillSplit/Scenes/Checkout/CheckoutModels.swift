//  
//  CheckoutModels.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 22/01/21.
//

import UIKit

enum Checkout {
    struct Show {
        struct Request {
            let expenses: [BillExpense]
        }

        struct Response {
            let expenses: [BillExpense]
        }

        struct ViewModel {
            var expenses: [BillExpense]

            var subtotalValue: Double {
                expenses.map({ $0.price * Double($0.quantity) }).reduce(0.0, +)
            }

            var serviceTaxValue: Double {
                subtotalValue * 0.1
            }

            var totalValueByAssignee: [String: Double] {
                Dictionary(grouping: expenses, by: { $0.assignee ?? "Not assigned" })
                    .mapValues({ $0.map({ $0.price * Double($0.quantity)  }).reduce(0.0, +) })
            }
        }
    }

    struct Payment {
        struct Request {
            let expenses: [BillExpense]
        }

        struct Response {
            let success: Bool
        }

        struct ViewModel {
            let titleText: String
            let messageText: String
        }
    }
}
