//
//  ExpensesWorkerTests.swift
//  BillSplitTests
//
//  Created by Matheus Oliveira Costa on 25/02/21.
//

import XCTest
@testable import BillSplit

class ExpensesWorkerTests: XCTestCase {

    let persistenceGateway = MockPersistenceGateway()

    func testContextIsSaved_afterCreateExpense() {
        let sut = ExpensesWorker(persistenceGateway: persistenceGateway)

        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: persistenceGateway.mainContext,
            handler: { notification in
                return true
            }
        )

        sut.createExpense(name: "Egg", price: 0.50, assigne: "Matheus", quantity: 3)

        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error, "Context wasn't saved")
        }
    }
}
