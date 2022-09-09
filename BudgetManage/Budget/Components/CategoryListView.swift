//
//  CategoryListView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CategoryListView: View {
    @Binding var budget: Budget
    @Binding var categoryTemplates: [CategoryTemplate]
    
    @State private var showCategoryDetailModalView: Bool = false
    @State private var selectedBudgetCategoryId: UUID? = nil
    
    @State private var showAddBudgetCategoryModalView: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("カテゴリ")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button {
                    self.showAddBudgetCategoryModalView = true
                } label: {
                    Text("編集")
                        .font(.callout)
                }
            }
            .padding(.horizontal, 8)
            VStack(spacing: 12) {
                Button(role: .none) {
                    self.selectedBudgetCategoryId = nil
                    self.showCategoryDetailModalView = true
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
                    self.showCategoryDetailModalView = true
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
        .sheet(isPresented: self.$showCategoryDetailModalView) {
            CategoryDetailModalView(
                budget: self.$budget,
                selectedCategoryId: self.$selectedBudgetCategoryId,
                showModalView: self.$showCategoryDetailModalView
            )
        }
        .sheet(isPresented: self.$showAddBudgetCategoryModalView) {
            AddBudgetCategoryModalView(
                showModalView: self.$showAddBudgetCategoryModalView,
                budget: self.$budget,
                categoryTemplates: self.$categoryTemplates
            )
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(UIColor.systemGray5)
            CategoryListView(
                budget: .constant(Budget.sampleData[0]),
                categoryTemplates: .constant(CategoryTemplate.sampleData)
            )
        }
    }
}
