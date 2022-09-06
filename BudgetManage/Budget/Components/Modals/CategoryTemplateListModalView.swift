//
//  CategoryListModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import SwiftUI

struct CategoryTemplateListModalView: View {
    @Binding var categoryTemplates: [CategoryTemplate]
    @Binding var budgetExpenses: [Expense]
    @Binding var showModalView: Bool
    @State var showCreateCategoryTemplateModalView: Bool = false
    
    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: CategoryTemplate? = nil

    var body: some View {
        NavigationView {
            List {
                if self.categoryTemplates.count == 0 {
                    HStack {
                        Spacer()
                        Text("カテゴリが登録されていません")
                        Spacer()
                    }
                    .listRowBackground(Color.red.opacity(0))
                }
                ForEach(self.categoryTemplates) { categoryTemplate in
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
//                            self.showEditModalView = true
//                            self.editTarget = expense
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
                    self.categoryTemplates.append(categoryTemplate)
                }
            }
            .alert("カテゴリの削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.deletionTarget) { categoryTemplate in
                    Button("削除", role: .destructive) {
                        let expenses = self.budgetExpenses.map { expense -> Expense in
                            var tmp = expense
                            if tmp.categoryId == deletionTarget?.id {
                                tmp.categoryId = nil
                            }
                            return tmp
                        }
                        self.budgetExpenses = expenses
                        let categoryTemplates = self.categoryTemplates.filter { $0.id != categoryTemplate.id }
                        self.categoryTemplates = categoryTemplates
                    }
            } message: { categoryTemplate in
                Text("カテゴリを削除しますか?\n削除したカテゴリが紐づいてる出費は未分類になります。")
            }
        }
    }
}

struct CategoryListModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTemplateListModalView(
            categoryTemplates: .constant([]),
            budgetExpenses: .constant([]),
            showModalView: .constant(true)
        )
    }
}
