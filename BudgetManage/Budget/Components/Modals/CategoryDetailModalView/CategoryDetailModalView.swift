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

    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>

    @Binding var selectedCategoryId: UUID?
    @Binding var showModalView: Bool
    @State private var selectedView: CategoryDetailViewType = .addExpense
    @State private var showEditBudgetCategoryModalView: Bool = false
    @State private var showDeleteConfirmAlert: Bool = false
    
    private var budgetCategory: BudgetCategoryCD? {
        return (self.uiStateEntities.first?.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first { budgetCategory in
            budgetCategory.id == self.selectedCategoryId
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let budgetCategory = self.budgetCategory {
                    CategoryTitle(categoryTitle: budgetCategory.title, categoryBalanceAmount: budgetCategory.balanceAmount)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    switch self.selectedView {
                    case .addExpense:
                        CategoryAddExpenseView(categoryId: self.selectedCategoryId) {
                            self.showModalView = false
                        }
                    case .detail:
                        CategoryDetailView(budgetCategory: budgetCategory)
                    }
                }
            }
            .background(Color(UIColor.systemGray6))
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
//                    TODO: CoreData内のデータを削除
//                    if var budget = self.budgetStore.selectedBudget {
//                        let categories = budget.categories.filter { $0.id != self.selectedCategoryId }
//                        let expenses = budget.expenses.map { expense -> Expense in
//                            var tmp: Expense = expense
//                            if expense.categoryId == self.selectedCategoryId {
//                                tmp.categoryId = nil
//                            }
//                            return tmp
//                        }
//                        budget.categories = categories
//                        budget.expenses = expenses
//                        self.budgetStore.selectedBudget = budget
//                        self.showDeleteConfirmAlert = false
//                        self.showModalView = false
//                    }
                }
            } message: {
                Text("予算からカテゴリを削除しますか？削除したカテゴリに紐づく出費は未分類になります。")
            }
            .sheet(isPresented: self.$showEditBudgetCategoryModalView) {
                EditBudgetCategoryDetailModalView(
                    selectedCategoryId: self.$selectedCategoryId
                )
            }
        }
    }
}

enum CategoryDetailViewType {
    case addExpense, detail
}
