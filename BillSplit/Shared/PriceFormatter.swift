//
//  PriceFormatter.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 18/12/20.
//

import Foundation

class PriceFormatter: NumberFormatter {
    override init() {
        super.init()
        numberStyle = .currency
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        numberStyle = .currency
    }
}
