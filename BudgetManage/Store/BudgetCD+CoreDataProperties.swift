//
//  BudgetCD+CoreDataProperties.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/15.
//
//

import Foundation
import CoreData


extension BudgetCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetCD> {
        return NSFetchRequest<BudgetCD>(entityName: "BudgetCD")
    }

    @NSManaged public var budgetAmount: Int32
    @NSManaged public var createdAt: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var uiState: UICD?
    @NSManaged public var budgetCategories: NSSet?

}

// MARK: Generated accessors for expenses
extension BudgetCD {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: ExpenseCD)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: ExpenseCD)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

// MARK: Generated accessors for budgetCategories
extension BudgetCD {

    @objc(addBudgetCategoriesObject:)
    @NSManaged public func addToBudgetCategories(_ value: BudgetCategoryCD)

    @objc(removeBudgetCategoriesObject:)
    @NSManaged public func removeFromBudgetCategories(_ value: BudgetCategoryCD)

    @objc(addBudgetCategories:)
    @NSManaged public func addToBudgetCategories(_ values: NSSet)

    @objc(removeBudgetCategories:)
    @NSManaged public func removeFromBudgetCategories(_ values: NSSet)

}

extension BudgetCD : Identifiable {
//    var uncategorizedBudgetAmount: Int32 {
//        let totalBudgetAmount = (self.budgetCategories?.allObjects as? [BudgetCategoryCD])?.reduce(0, { x, y in
//            x + y.budgetAmount
//        }) ?? 0
//        return self.budgetAmount - totalBudgetAmount
//    }
    
//    var uncategorizedExpenses: [ExpenseCD] {
//        (self.expenses?.allObjects as? [ExpenseCD])?.filter { $0.budgetCategory == nil } ?? [] as [ExpenseCD]
//    }
    
    var uncategorizedBudgetCategory: BudgetCategoryCD? {
        (self.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first { category in
            category.title == "未分類"
        }
    }
}
