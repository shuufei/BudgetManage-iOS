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
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let budgets):
                    continuation.resume(returning: budgets)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Budget], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let budgets = try JSONDecoder().decode([Budget].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(budgets))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(budgets: [Budget]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(budgets: budgets) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let budgetsSaved):
                    continuation.resume(returning: budgetsSaved)
                }
                
            }
        }
    }
    
    static func save(budgets: [Budget], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(budgets)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(budgets.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
