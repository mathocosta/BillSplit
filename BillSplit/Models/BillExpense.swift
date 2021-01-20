//
//  BillExpense.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 18/12/20.
//

import Foundation

struct BillExpense: Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    var price: Float = 0.0
    var assignee: String? = nil
    var quantity: Int = 1
}
