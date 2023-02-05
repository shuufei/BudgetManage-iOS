//
//  CategoryCard.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CategoryCard: View {
    @Environment(\.colorScheme) private var colorScheme
    var budgetCategoryTitle: String
    var budgetAmount: Int32
    var budgetBalanceAmount: Int32
    var budgetCategoryMainColor: Color

    private var isDeficit: Bool {
        self.budgetBalanceAmount < 0
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(self.budgetCategoryTitle)
                    .font(.headline)
                Spacer()
                HStack(spacing: 4) {
                    Text("残り")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text("¥\(self.budgetBalanceAmount)")
                        .font(.headline)
                        .foregroundColor(self.isDeficit ? .red : getDefaultForegroundColor(self.colorScheme))
                }
            }
            CategoryBudgetBar(budgetAmount: self.budgetAmount, budgetBalanceAmount: self.budgetBalanceAmount, mainColor: self.budgetCategoryMainColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(getDefaultBackgroundColor(self.colorScheme))
        .cornerRadius(8)
    }
}
