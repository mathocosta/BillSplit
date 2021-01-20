//  
//  BillModels.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import UIKit

enum Bill {
    enum FetchItems {
        struct Request {
        }

        struct Response {
            let expenses: [Expense]
        }

        struct DisplayedExpense: Identifiable {
            let id: UUID
            let name: String
            let price: Float
            let assignee: String?
            let quantity: Int
        }

        struct ViewModel {
            var displayedExpenses: [DisplayedExpense]
        }
    }
}
