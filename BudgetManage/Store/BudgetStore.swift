//
//  BudgetStore.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import Foundation

class BudgetStore: ObservableObject {
    @Published var budgets: [Budget] = Budget.sampleData {
        didSet {
            print("--- didSet budgets: \(budgets)")
            Task {
                do {
                    try await BudgetStore.save(budgets: self.budgets)
                } catch {
//                    TODO: handling error
                }
            }
        }
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("budget.data")
    }
    
    static func load() async throws -> [Budget] {
        try await FileBaseStore.load(fileURL: self.fileURL)
    }
    
    @discardableResult
    static func save(budgets: [Budget]) async throws -> Int {
        try await FileBaseStore.save(budgets: budgets, fileURL: self.fileURL)
    }
}
