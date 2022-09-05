//
//  CategoryStore.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import Foundation

class CategoryTemplateStore: ObservableObject {
    @Published var categories: [CategoryTemplate] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("category-template.data")
    }
    
    static func load() async throws -> [CategoryTemplate] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let categoryTemplates):
                    continuation.resume(returning: categoryTemplates)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[CategoryTemplate], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try self.fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let cateogyTemplates = try JSONDecoder().decode([CategoryTemplate].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(cateogyTemplates))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(categoryTemplates: [CategoryTemplate]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(categoryTemplates: categoryTemplates) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let categoryTemplatesSaved):
                    continuation.resume(returning: categoryTemplatesSaved)
                }
                
            }
        }
    }
    
    static func save(categoryTemplates: [CategoryTemplate], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(categoryTemplates)
                let outfile = try self.fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(categoryTemplates.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

}
