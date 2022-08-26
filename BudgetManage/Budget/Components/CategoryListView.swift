//
//  CategoryListView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CategoryListView: View {
    @Binding var budget: Budget
    
    private var uncategorizedBudgetAmount: Int {
        let totalBudgetAmount = self.budget.categories.reduce(0, { x, y in
            x + y.budgetAmount
        })
        return budget.budgetAmount - totalBudgetAmount
    }
    
    private var uncategorizedExpenses: [Expense] {
        self.budget.expenses.filter { $0.categoryId == nil }
    }
    
    var body: some View {
        CategoryCard(budgetCategory: .uncategorized(UnCategorized(title: "未分類", budgetAmount: self.uncategorizedBudgetAmount)), expenses: self.uncategorizedExpenses)
            .padding()
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(budget: .constant(Budget.sampleData[0]))
    }
}
