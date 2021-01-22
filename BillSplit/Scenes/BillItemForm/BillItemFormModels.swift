//  
//  BillItemFormModels.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import UIKit

enum BillItemForm {
    struct FormFields {
        var itemName: String = ""
        var itemPrice: Double = 0.0
        var itemAssignee: String?
        var itemQuantity: Int = 1
    }

    struct EditItem {
        struct Request {
        }

        struct Response {
            let itemToEdit: BillExpense?
        }

        struct ViewModel {
            let name: String
            let price: Double
            let assignee: String
            let quantity: Int
        }
    }

    struct CreateItem {
        struct Request {
            let fieldValues: FormFields
        }

        struct Response {
        }

        struct ViewModel {
        }
    }

    struct UpdateItem {
        struct Request {
            let fieldValues: FormFields
        }

        struct Response {
        }

        struct ViewModel {
        }
    }
}
