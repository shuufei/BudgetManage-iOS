//
//  BudgetManageApp.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

@main
struct BudgetManageApp: App {
    let persistenceController = PersistenceCoreDataController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BudgetStore())
                .environmentObject(CategoryTemplateStore())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
