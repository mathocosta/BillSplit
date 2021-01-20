//  
//  BillItemFormModels.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import UIKit

enum BillItemForm {
    struct FormFields {
        let itemName: String
        let itemPrice: Float
        let itemAssignee: String?
        let itemQuantity: Int
    }

    struct EditItem {
        struct Request {
        }

        struct Response {
            let itemToEdit: BillExpense?
        }

        struct ViewModel {
            let name: String
            let price: Float
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
