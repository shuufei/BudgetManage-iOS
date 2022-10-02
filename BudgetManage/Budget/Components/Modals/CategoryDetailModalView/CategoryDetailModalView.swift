//
//  CategoryDetailModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI

struct CategoryDetailModalView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    @Binding var selectedCategoryId: UUID?
    @Binding var showModalView: Bool
    
    @State private var selectedView: CategoryDetailViewType = .addExpense
    
    @State private var showEditBudgetCategoryModalView: Bool = false
    @State private var showDeleteConfirmAlert: Bool = false
    
    private var budgetCategory: BudgetCategory? {
        if let budget = self.budgetStore.selectedBudget {
            if let category = budget.categories.first(
                where: { $0.id == self.selectedCategoryId }
            ), let categoryTemplate = self.categoryTemplateStore.categories.first(
                where: { $0.id == category.categoryTemplateId }
            )  {
                let categoryExpenses = budget.expenses.filter { $0.categoryId == category.id }
                return .categorized(category, categoryTemplate, categoryExpenses)
            } else {
                return .uncategorized(
                    UnCategorized(
                        title: "未分類",
                        budgetAmount: budget.uncategorizedBudgetAmount
                    ),
                    budget.uncategorizedExpenses
                )
            }
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let budgetCategory = self.budgetCategory {
                    CategoryTitle(category: budgetCategory)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    switch self.selectedView {
                    case .addExpense:
                        CategoryAddExpenseView(categoryId: self.selectedCategoryId) {
                            self.showModalView = false
                        }
                    case .detail:
                        CategoryDetailView(
                            selectedCategoryId: self.$selectedCategoryId,
                            budgetCategory: budgetCategory
                        )
                    }
                }
            }
            .background(Color(UIColor.systemGray6))
            .navigationTitle(self.budgetStore.selectedBudget?.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(self.selectedView == .addExpense ? "キャンセル" : "閉じる") {
                        self.showModalView = false
                    }
                }
                ToolbarItem(placement: .principal) {
                    Picker("", selection: self.$selectedView) {
                        Text("出費").tag(CategoryDetailViewType.addExpense)
                        Text("詳細").tag(CategoryDetailViewType.detail)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
                ToolbarItem(placement: .primaryAction) {
                    if self.selectedCategoryId != nil && self.selectedView == .detail {
                        Menu {
                            Button {
                                self.showEditBudgetCategoryModalView = true
                            } label: {
                                Label("編集", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                self.showDeleteConfirmAlert = true
                            } label: {
                                Label("削除...", systemImage: "trash")
                            }
                        } label: {
                            Button {} label: {
                                Image(systemName: "ellipsis")
                            }
                            .accessibilityLabel("open menu")
                        }
                    }
                }
                
            }
            .alert("予算カテゴリの削除", isPresented: self.$showDeleteConfirmAlert) {
                Button("削除", role: .destructive) {
                    if var budget = self.budgetStore.selectedBudget {
                        let categories = budget.categories.filter { $0.id != self.selectedCategoryId }
                        let expenses = budget.expenses.map { expense -> Expense in
                            var tmp: Expense = expense
                            if expense.categoryId == self.selectedCategoryId {
                                tmp.categoryId = nil
                            }
                            return tmp
                        }
                        budget.categories = categories
                        budget.expenses = expenses
                        self.budgetStore.selectedBudget = budget
                        self.showDeleteConfirmAlert = false
                        self.showModalView = false
                    }
                }
            } message: {
                Text("予算からカテゴリを削除しますか？削除したカテゴリに紐づく出費は未分類になります。")
            }
            .sheet(isPresented: self.$showEditBudgetCategoryModalView) {
                EditBudgetCategoryDetailModalView(
                    selectedCategoryId: self.$selectedCategoryId,
                    showModalView: self.$showEditBudgetCategoryModalView
                )
            }
        }
    }
}

struct CategoryDetailModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailModalView(
            selectedCategoryId: .constant(Budget.sampleData[0].categories[0].id),
            showModalView: .constant(true)
        )
            .environmentObject(BudgetStore())
            .environmentObject(CategoryTemplateStore())
        
    }
}

enum CategoryDetailViewType {
    case addExpense, detail
}
