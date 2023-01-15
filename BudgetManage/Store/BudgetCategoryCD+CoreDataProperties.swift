//
//  BudgetCategoryCD+CoreDataProperties.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/15.
//
//

import Foundation
import CoreData
import UIKit
import SwiftUI


extension BudgetCategoryCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetCategoryCD> {
        return NSFetchRequest<BudgetCategoryCD>(entityName: "BudgetCategoryCD")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var budgetAmount: Int32
    @NSManaged public var createdAt: Date?
    @NSManaged public var categoryTemplate: CategoryTemplateCD?
    @NSManaged public var budget: BudgetCD?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension BudgetCategoryCD {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: ExpenseCD)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: ExpenseCD)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension BudgetCategoryCD : Identifiable {
    var title: String {
        self.categoryTemplate?.title ?? "未分類"
    }
    var expensesArray: [ExpenseCD] {
        self.expenses?.allObjects as? [ExpenseCD] ?? []
    }
    var balanceAmount: Int32 {
        self.budgetAmount - self.getTotalExpenseAmount(self.expensesArray)
    }
    var totalExpensesAmount: Int32 {
        self.getTotalExpenseAmount(self.expensesArray)
    }
    var mainColor: Color {
        self.categoryTemplate?.theme.mainColor ?? Color(UIColor.systemGray)
    }
    var accentColor: Color {
        self.categoryTemplate?.theme.accentColor ?? .primary
    }
    
    private func getTotalExpenseAmount(_ expenses: [ExpenseCD]) -> Int32 {
        expenses.reduce(0, { x, y in
            x + Int32(y.amount)
        })
    }
}
