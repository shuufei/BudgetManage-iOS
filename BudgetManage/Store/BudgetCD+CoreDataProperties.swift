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

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var budgetAmount: Int32
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var isActive: Bool
    @NSManaged public var expenses: NSSet?

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

extension BudgetCD : Identifiable {

}
