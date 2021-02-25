//  
//  BillItemFormModels.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import UIKit

enum BillItemForm {
    enum SavingError: LocalizedError {
        case missingName, invalidPrice, undefined

        var errorDescription: String? {
            switch self {
            case .missingName:
                return "O nome não pode ser vazio"
            case .invalidPrice:
                return "Preço inválido"
            default:
                return nil
            }
        }
    }

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

    struct SaveItem {
        struct Request {
            let fieldValues: FormFields
        }

        struct Response {
            let success: Bool
            var error: Error? = nil
        }

        struct ViewModel {
            let success: Bool
            var titleText: String? = nil
            var messageText: String? = nil
        }
    }

    typealias CreateItem = SaveItem
    typealias UpdateItem = SaveItem
}
