//
//  BillSplitApp.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

@main
struct BillSplitApp: App {
    let persistenceWorker = PersistenceWorker()

    var body: some Scene {
        WindowGroup {
            BillView()
                .environmentObject(
                    BillStore(managedObjectContext: persistenceWorker.managedObjectContext)
                )
        }
    }
}
