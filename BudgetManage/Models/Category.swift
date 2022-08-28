//
//  Category.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import Foundation
import SwiftUI

struct CategoryTemplate: Codable, Hashable, Identifiable {
    var id: UUID
    var title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

struct Category: Codable, Hashable, Identifiable {
    var id: UUID
    var categoryTemplateId: UUID
    var budgetAmount: Int
    
    init(categoryTemplateId: UUID, budgetAmount: Int) {
        self.id = UUID()
        self.categoryTemplateId = categoryTemplateId
        self.budgetAmount = budgetAmount
    }
}

struct UnCategorized {
    var title: String
    var budgetAmount: Int
}

enum BudgetCategory {
    case categorized(Category, CategoryTemplate, [Expense])
    case uncategorized(UnCategorized, [Expense])
    
    private func getTotalExpenseAmount(_ expenses: [Expense]) -> Int {
        expenses.reduce(0, { x, y in
            x + y.amount
        })
    }
    
    func displayData() -> CategoryDisplayData {
        switch self {
        case let .uncategorized(uncategorized, expenses):
            return CategoryDisplayData(
                title: uncategorized.title,
                budgetAmount: uncategorized.budgetAmount,
                balanceAmount: uncategorized.budgetAmount - self.getTotalExpenseAmount(expenses),
                color: Color(UIColor.systemGray))
        case let .categorized(category, categoryTemplate, expenses):
            return CategoryDisplayData(
                title: categoryTemplate.title,
                budgetAmount: category.budgetAmount,
                balanceAmount: category.budgetAmount - self.getTotalExpenseAmount(expenses),
                color: Color.green
            )
        }
    }
    
    struct CategoryDisplayData {
        var title: String
        var budgetAmount: Int
        var balanceAmount: Int
        var color: Color
    }
}

extension CategoryTemplate {
    static let sampleData = [
        CategoryTemplate(title: "食費"),
        CategoryTemplate(title: "飲み代"),
    ]
}

extension Category {
    static let sampleData = [
        Category(categoryTemplateId: CategoryTemplate.sampleData[0].id, budgetAmount: 40000),
        Category(categoryTemplateId: CategoryTemplate.sampleData[1].id, budgetAmount: 50000),
    ]
}
