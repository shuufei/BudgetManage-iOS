//
//  CategoryListModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import SwiftUI

struct CategoryTemplateListModalView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    @Binding var showModalView: Bool

    @State private var showCreateCategoryTemplateModalView: Bool = false

    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: CategoryTemplate? = nil

    @State private var editTarget: CategoryTemplate? = nil

    var body: some View {
        NavigationView {
            List {
                if self.categoryTemplateStore.categories.count == 0 {
                    HStack {
                        Spacer()
                        Text("カテゴリが登録されていません")
                        Spacer()
                    }
                    .listRowBackground(Color.red.opacity(0))
                }
                ForEach(self.categoryTemplateStore.categories) { categoryTemplate in
                    HStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(categoryTemplate.theme.mainColor)
                                .frame(width: 24, height: 24)
                                .foregroundColor(categoryTemplate.theme.accentColor)
                            Text(categoryTemplate.title)
                            Spacer()
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            self.showDeleteConfirmAlert = true
                            self.deletionTarget = categoryTemplate
                        } label: {
                            Text("削除")
                        }
                        Button(role: .none) {
                            self.editTarget = categoryTemplate
                        } label: {
                            Text("編集")
                        }
                        .tint(.gray)
                    }
                }
            }
            .navigationTitle("カテゴリ一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        self.showModalView = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showCreateCategoryTemplateModalView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: self.$showCreateCategoryTemplateModalView) {
                CreateCategoryTemplateModalView(showModalView: self.$showCreateCategoryTemplateModalView) { categoryTemplate in
                    self.categoryTemplateStore.categories.append(categoryTemplate)
                }
            }
            .alert("カテゴリの削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.deletionTarget) { categoryTemplate in
                    Button("削除", role: .destructive) {
                        if var budget = self.budgetStore.selectedBudget {
                            let expenses = budget.expenses.map { expense -> Expense in
                                var tmp = expense
                                if tmp.categoryId == deletionTarget?.id {
                                    tmp.categoryId = nil
                                }
                                return tmp
                            }
                            budget.expenses = expenses
                            self.budgetStore.selectedBudget = budget
                            let categoryTemplates = self.categoryTemplateStore.categories.filter { $0.id != categoryTemplate.id }
                            self.categoryTemplateStore.categories = categoryTemplates
                        }
                    }
            } message: { categoryTemplate in
                Text("カテゴリを削除しますか?\n削除したカテゴリが紐づいてる出費は未分類になります。")
            }
            .sheet(item: self.$editTarget) { editTarget in
                EditCategoryTemplateModalView(
                    categoryTemplateId: editTarget.id
                )
            }
        }
    }
}

struct CategoryListModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTemplateListModalView(
            showModalView: .constant(true)
        )
            .environmentObject(BudgetStore())
            .environmentObject(CategoryTemplateStore())
    }
}
