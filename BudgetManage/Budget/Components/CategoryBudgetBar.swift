//
//  CategoryBudgetBar.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/03.
//

import SwiftUI

struct CategoryBudgetBar: View {
    var budgetCategory: BudgetCategory
    
    @State private var totalHeight = CGFloat(0)
    private let barHeight: CGFloat = 20
    private var data: BudgetCategory.CategoryDisplayData {
        self.budgetCategory.displayData()
    }
    
    private var balanceAmountRate: CGFloat {
        let rate = CGFloat(self.data.balanceAmount) / CGFloat(self.data.budgetAmount)
        return rate.isNaN || (!rate.isNaN && rate < 0) ? 0 : rate
    }
    
    private var totalExpenseAmountRate: CGFloat {
        CGFloat(1) - self.balanceAmountRate
    }
    
    private func getBalanceAmountBarWidth(_ geometryWidth: CGFloat) -> CGFloat {
        let width = geometryWidth;
        return width >= 0 ? width * self.balanceAmountRate : 0;
    }
    
    private func getTotalExpenseAmountBarWidth(_ geometryWidth: CGFloat) -> CGFloat {
        let width = geometryWidth;
        return width >= 0 ? width * self.totalExpenseAmountRate : 0;
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 2) {
                HStack(spacing: 0) {
                    self.data.mainColor
                        .frame(width: self.getBalanceAmountBarWidth(geometry.size.width), height: self.barHeight)
                    Color(UIColor.systemGray5).frame(width: self.getTotalExpenseAmountBarWidth(geometry.size.width), height: self.barHeight)
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
            .background(GeometryReader { gp -> Color in
                DispatchQueue.main.async {
                    self.totalHeight = gp.size.height
                }
                return Color.clear
            })
        }
        .frame(height: self.totalHeight)
    }
}

struct CategoryBudgetBar_Previews: PreviewProvider {
    static var previews: some View {
        CategoryBudgetBar(
            budgetCategory: .uncategorized(
                UnCategorized(title: "未分類", budgetAmount: 40000),
                Expense.sampleData
            )
        )
    }
}
