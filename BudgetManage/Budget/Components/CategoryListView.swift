//
//  CategoryListView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CategoryListView: View {
    @Binding var budget: Budget
    @State var showCategoryDetail: Bool = false
    @State private var selectedBudgetCategoryId: UUID? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("カテゴリ")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 8)
            VStack(spacing: 12) {
                Button(role: .none) {
                    self.selectedBudgetCategoryId = nil
                    self.showCategoryDetail = true
                } label: {
                    CategoryCard(
                        budgetCategory: .uncategorized(
                            UnCategorized(title: "未分類", budgetAmount: self.budget.uncategorizedBudgetAmount),
                            self.budget.uncategorizedExpenses
                        )
                    )
                }
                .buttonStyle(.plain)
                Button(role: .none) {
                    self.selectedBudgetCategoryId = nil
                    self.showCategoryDetail = true
                } label: {
                    CategoryCard(
                        budgetCategory: .uncategorized(
                            UnCategorized(title: "未分類", budgetAmount: self.budget.uncategorizedBudgetAmount),
                            self.budget.uncategorizedExpenses
                        )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: self.$showCategoryDetail) {
            CategoryDetailModalView(
                budget: self.$budget,
                selectedCategoryId: self.$selectedBudgetCategoryId,
                showModalView: self.$showCategoryDetail
            )
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(UIColor.systemGray5)
            CategoryListView(budget: .constant(Budget.sampleData[0]))
        }
    }
}
