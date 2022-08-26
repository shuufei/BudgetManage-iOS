//
//  CategoryCard.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

fileprivate struct CategoryCardData {
    var title: String
    var budgetAmount: Int
    var balanceAmount: Int
    var color: Color
}

struct CategoryCard: View {
    @Environment(\.colorScheme) var colorScheme
    var budgetCategory: BudgetCategory
    var expenses: [Expense] = []
    
    private let horizontalPadding: CGFloat = 12
    private let verticalPadding: CGFloat = 12
    private let barHeight: CGFloat = 20
    
    private var totalExpenseAmount: Int {
        self.expenses.reduce(0, { x, y in
            x + y.amount
        })
    }
    
    private var data: CategoryCardData {
        switch self.budgetCategory {
        case let .uncategorized(uncategorized):
            return CategoryCardData(title: uncategorized.title, budgetAmount: uncategorized.budgetAmount, balanceAmount: uncategorized.budgetAmount - self.totalExpenseAmount, color: Color(UIColor.systemGray))
        case let .categorized(category, categoryTemplate):
            return CategoryCardData(title: categoryTemplate.title, budgetAmount: category.budgetAmount, balanceAmount: category.budgetAmount - self.totalExpenseAmount, color: Color.green)
        }
    }
    
    private var balanceAmountRate: CGFloat {
        CGFloat(self.data.balanceAmount) / CGFloat(self.data.budgetAmount)
    }
    
    private var totalExpenseAmountRate: CGFloat {
        CGFloat(1) - self.balanceAmountRate
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                        }
                    }
                    VStack(spacing: 2) {
                        HStack(spacing: 0) {
                            self.data.color
                                .frame(width: (geometry.size.width - self.horizontalPadding * 2) * self.balanceAmountRate, height: self.barHeight)
                            Color(UIColor.systemGray5).frame(width: (geometry.size.width - self.horizontalPadding * 2) * self.totalExpenseAmountRate, height: self.barHeight)
                        }
                        .cornerRadius(3)
                        HStack {
                            Text("¥0")
                            Spacer()
                            Text("¥\(self.data.budgetAmount)")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, self.horizontalPadding)
            .padding(.vertical, self.verticalPadding)
            .background(self.colorScheme == .dark ? .black : .white)
            .cornerRadius(5)
        }
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(budgetCategory: .uncategorized(UnCategorized(title: "未分類", budgetAmount: 40000)), expenses: Expense.sampleData)
    }
}