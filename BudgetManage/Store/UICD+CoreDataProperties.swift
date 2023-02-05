//
//  UICD+CoreDataProperties.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/15.
//
//

import Foundation
import CoreData


extension UICD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UICD> {
        return NSFetchRequest<UICD>(entityName: "UICD")
    }

    @NSManaged public var updatedAt: Date?
    @NSManaged public var activeBudget: BudgetCD?

}

extension UICD : Identifiable {

}
