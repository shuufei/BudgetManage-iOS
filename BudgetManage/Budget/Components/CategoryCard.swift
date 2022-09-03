//
//  CategoryCard.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CategoryCard: View {
    @Environment(\.colorScheme) var colorScheme
    var budgetCategory: BudgetCategory

    private var data: BudgetCategory.CategoryDisplayData {
        self.budgetCategory.displayData()
    }

    private var isDeficit: Bool {
        self.data.balanceAmount < 0
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(self.data.title)
                    .font(.headline)
                Spacer()
                HStack(spacing: 4) {
                    Text("残り")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text("¥\(self.data.balanceAmount)")
                        .font(.headline)
                        .foregroundColor(self.isDeficit ? .red : getDefaultForegroundColor(self.colorScheme))
                }
            }
            CategoryBudgetBar(budgetCategory: self.budgetCategory)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(getDefaultBackgroundColor(self.colorScheme))
        .cornerRadius(8)
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(
            budgetCategory: .uncategorized(
                UnCategorized(title: "未分類", budgetAmount: 40000),
                Expense.sampleData
            )
        )
    }
}
