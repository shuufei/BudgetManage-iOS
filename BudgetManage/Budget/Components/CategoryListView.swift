//
//  CategoryListView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    @State private var showCategoryDetailModalView: Bool = false
    @State private var selectedBudgetCategoryId: UUID? = nil
    
    @State private var showAddBudgetCategoryModalView: Bool = false
    
    private func getCategoryTemplate(categoryTemplateId: UUID) -> CategoryTemplate? {
        self.categoryTemplateStore.categories.first { $0.id == categoryTemplateId }
    }
    
    private func getCategoryExpenses(categoryId: UUID) -> [Expense] {
        self.budgetStore.selectedBudget?.expenses.filter { $0.categoryId == categoryId } ?? []
    }
    
    private func getBudgetCategory(category: Category) -> BudgetCategory {
        if let categoryTemplate = self.getCategoryTemplate(categoryTemplateId: category.categoryTemplateId) {
            return .categorized(category, categoryTemplate, self.getCategoryExpenses(categoryId: category.id))
        } else {
            return .uncategorized(UnCategorized(title: "", budgetAmount: 0), [])
        }
    }
    
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
                if let budget = self.budgetStore.selectedBudget {
                    ForEach(budget.categories) { category in
                        Button(role: .none) {
                            self.selectedBudgetCategoryId = category.id
                            self.showCategoryDetailModalView = true
                        } label: {
                            CategoryCard(
                                budgetCategory: self.getBudgetCategory(category: category)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Button(role: .none) {
                        self.selectedBudgetCategoryId = nil
                        self.showCategoryDetailModalView = true
                    } label: {
                        CategoryCard(
                            budgetCategory: .uncategorized(
                                UnCategorized(
                                    title: "未分類",
                                    budgetAmount: budget.uncategorizedBudgetAmount
                                ),
                                budget.uncategorizedExpenses
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
                
            }
        }
        .sheet(isPresented: self.$showCategoryDetailModalView) {
            CategoryDetailModalView(
                selectedCategoryId: self.$selectedBudgetCategoryId,
                showModalView: self.$showCategoryDetailModalView
            )
        }
        .sheet(isPresented: self.$showAddBudgetCategoryModalView) {
            EditBudgetCategoryModalView(
                showModalView: self.$showAddBudgetCategoryModalView
            )
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(UIColor.systemGray5)
            CategoryListView()
                .environmentObject(BudgetStore())
                .environmentObject(CategoryTemplateStore())
        }
    }
}
