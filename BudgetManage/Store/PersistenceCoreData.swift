//
//  PersistentCoreData.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/15.
//

import CoreData

struct PersistenceCoreDataController {
    static let shared = PersistenceCoreDataController()
    
    static var preview: PersistenceCoreDataController = {
        let result = PersistenceCoreDataController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<3 {
            let newBudget = BudgetCD(context: viewContext)
            newBudget.id = UUID()
            newBudget.title = "予算タイトル\(index + 1)"
            newBudget.budgetAmount = 150000
            newBudget.startDate = Date()
            newBudget.endDate = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BudgetDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
