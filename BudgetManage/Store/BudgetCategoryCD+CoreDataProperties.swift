//
//  BudgetCategoryCD+CoreDataProperties.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/15.
//
//

import Foundation
import CoreData


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

}
