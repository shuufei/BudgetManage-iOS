//
//  CategoryDetailModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI

struct CategoryDetailModalView: View {
    @Binding var budget: Budget
    @Binding var selectedCategoryId: UUID?
    @Binding var showModalView: Bool
    @Binding var categoryTemplates: [CategoryTemplate]
    
    @State private var selectedView: CategoryDetailViewType = .addExpense
    
    @State private var showEditBudgetCategoryModalView: Bool = false
    @State private var showDeleteConfirmAlert: Bool = false
    
    private var budgetCategory: BudgetCategory {
        if let category = self.budget.categories.first(where: { $0.id == self.selectedCategoryId }), let categoryTemplate = self.categoryTemplates.first(where: { $0.id == category.categoryTemplateId })  {
            let categoryExpenses = self.budget.expenses.filter { $0.categoryId == category.id }
            return .categorized(category, categoryTemplate, categoryExpenses)
        } else {
            return .uncategorized(UnCategorized(title: "未分類", budgetAmount: self.budget.uncategorizedBudgetAmount), self.budget.uncategorizedExpenses)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CategoryTitle(category: self.budgetCategory)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                switch self.selectedView {
                case .addExpense:
                    CategoryAddExpenseView(budget: self.$budget, categoryId: self.selectedCategoryId) {
                        self.showModalView = false
                    }
                case .detail:
                    CategoryDetailView(
                        budget: self.$budget,
                        selectedCategoryId: self.$selectedCategoryId,
                        categoryTemplates: self.$categoryTemplates,
                        budgetCategory: self.budgetCategory
                    )
                }
            }
            .background(Color(UIColor.systemGray6))
            .navigationTitle(self.budget.title)
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
                    self.budget.categories = self.budget.categories.filter { $0.id != self.selectedCategoryId }
                    self.budget.expenses = self.budget.expenses.map { expense in
                        var tmp = expense
                        if expense.categoryId == self.selectedCategoryId {
                            tmp.categoryId = nil
                        }
                        return tmp
                    }
                    self.showDeleteConfirmAlert = false
                    self.showModalView = false
                }
            } message: {
                Text("予算からカテゴリを削除しますか？削除したカテゴリに紐づく出費は未分類になります。")
            }
            .sheet(isPresented: self.$showEditBudgetCategoryModalView) {
                EditBudgetCategoryDetailModalView(budget: self.$budget, selectedCategoryId: self.$selectedCategoryId, showModalView: self.$showEditBudgetCategoryModalView, categoryTemplates: self.$categoryTemplates)
            }
        }
    }
}

struct CategoryDetailModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailModalView(
            budget: .constant(Budget.sampleData[0]),
            selectedCategoryId: .constant(Budget.sampleData[0].categories[0].id),
            showModalView: .constant(true),
            categoryTemplates: .constant(CategoryTemplate.sampleData)
        )
    }
}

enum CategoryDetailViewType {
    case addExpense, detail
}
