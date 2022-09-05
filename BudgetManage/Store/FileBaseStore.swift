//
//  FileBaseStore.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import Foundation

class FileBaseStore {
    static func load(fileURL: @escaping () throws -> URL) async throws -> [Budget] {
        try await withCheckedThrowingContinuation { continuation in
            load(fileURL: fileURL) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let budgets):
                    continuation.resume(returning: budgets)
                }
            }
        }
    }
    
    static func load(fileURL: @escaping () throws -> URL, completion: @escaping (Result<[Budget], Error>) -> Void) {
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
    static func save(budgets: [Budget], fileURL: @escaping () throws -> URL) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(budgets: budgets, fileURL: fileURL) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let budgetsSaved):
                    continuation.resume(returning: budgetsSaved)
                }
                
            }
        }
    }
    
    static func save(budgets: [Budget], fileURL: @escaping () throws -> URL, completion: @escaping (Result<Int, Error>) -> Void) {
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

