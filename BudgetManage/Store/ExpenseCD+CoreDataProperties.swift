//
//  ExpenseCD+CoreDataProperties.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/15.
//
//

import Foundation
import CoreData


extension ExpenseCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseCD> {
        return NSFetchRequest<ExpenseCD>(entityName: "ExpenseCD")
    }

    @NSManaged public var amount: Int32
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var includeTimeInDate: Bool
    @NSManaged public var memo: String?
    @NSManaged public var budget: BudgetCD?

}

extension ExpenseCD : Identifiable {

}
