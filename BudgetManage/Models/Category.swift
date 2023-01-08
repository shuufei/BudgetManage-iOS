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
    var theme: Theme
    
    init(title: String, theme: Theme) {
        self.id = UUID()
        self.title = title
        self.theme = theme
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
                mainColor: Color(UIColor.systemGray),
                accentColor: .primary
            )
        case let .categorized(category, categoryTemplate, expenses):
            return CategoryDisplayData(
                title: categoryTemplate.title,
                budgetAmount: category.budgetAmount,
                balanceAmount: category.budgetAmount - self.getTotalExpenseAmount(expenses),
                mainColor: categoryTemplate.theme.mainColor,
                accentColor: categoryTemplate.theme.accentColor,
                categoryTemplateId: categoryTemplate.id
            )
        }
    }
    
    struct CategoryDisplayData: Hashable {
        var title: String
        var budgetAmount: Int
        var balanceAmount: Int
        var mainColor: Color
        var accentColor: Color
        var categoryTemplateId: UUID?
        var categoryId: UUID?
        
        var totalExpenseAmount: Int {
            self.budgetAmount - self.balanceAmount
        }
    }
}

extension CategoryTemplate {
    static let sampleData = [
        CategoryTemplate(title: "食費", theme: .yellow),
        CategoryTemplate(title: "飲み代", theme: .red),
    ]
}

extension Category {
    static let sampleData = [
        Category(categoryTemplateId: CategoryTemplate.sampleData[0].id, budgetAmount: 40000),
        Category(categoryTemplateId: CategoryTemplate.sampleData[1].id, budgetAmount: 50000),
    ]
}

func getBudgetCategorieDisplayDataList(categories: [Category], categoryTemplates: [CategoryTemplate]) -> [BudgetCategory.CategoryDisplayData] {
    categories.map { category in
        let categoryTemplate = categoryTemplates.first { $0.id == category.categoryTemplateId }
        return BudgetCategory.CategoryDisplayData(
            title: categoryTemplate!.title,
            budgetAmount: category.budgetAmount,
            balanceAmount: 0,
            mainColor: categoryTemplate!.theme.mainColor,
            accentColor: categoryTemplate!.theme.accentColor,
            categoryTemplateId: categoryTemplate!.id,
            categoryId: category.id
        )
    }
}

extension BudgetCategory: Equatable {
    static func == (lhs: BudgetCategory, rhs: BudgetCategory) -> Bool {
        return
            lhs.displayData().categoryId == rhs.displayData().categoryId &&
            lhs.displayData().balanceAmount == rhs.displayData().balanceAmount &&
            lhs.displayData().totalExpenseAmount == rhs.displayData().totalExpenseAmount
    }
}
