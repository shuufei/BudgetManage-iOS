//
//  CategoryTemplateCD+CoreDataProperties.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/15.
//
//

import Foundation
import CoreData


extension CategoryTemplateCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryTemplateCD> {
        return NSFetchRequest<CategoryTemplateCD>(entityName: "CategoryTemplateCD")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var themeName: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var budgetCategories: NSSet?

}

// MARK: Generated accessors for budgetCategories
extension CategoryTemplateCD {

    @objc(addBudgetCategoriesObject:)
    @NSManaged public func addToBudgetCategories(_ value: BudgetCategoryCD)

    @objc(removeBudgetCategoriesObject:)
    @NSManaged public func removeFromBudgetCategories(_ value: BudgetCategoryCD)

    @objc(addBudgetCategories:)
    @NSManaged public func addToBudgetCategories(_ values: NSSet)

    @objc(removeBudgetCategories:)
    @NSManaged public func removeFromBudgetCategories(_ values: NSSet)

}

extension CategoryTemplateCD : Identifiable {
    var theme: Theme {
        switch self.themeName {
        case "Yellow":
            return .yellow
        case "Red":
            return .red
        case "Green":
            return .green
        case "Orange":
            return .orange
        case "Magenta":
            return .magenta
        case "Sky":
            return .sky
        case "Poppy":
            return .poppy
        case "Tan":
            return .tan
        case "Teal":
            return .teal
        case "Periwinkle":
            return .periwinkle
        case "Purple":
            return .purple
        case "Bubblegum":
            return .bubblegum
        default:
            return .yellow
        }
    }
}
