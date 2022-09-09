//
//  CreateBudgetCategoryModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import SwiftUI

struct EditBudgetCategoryModalView: View {
    @Binding var showModalView: Bool
    @Binding var budget: Budget
    @Binding var categoryTemplates: [CategoryTemplate]
    
    @State private var showAddConfirmAlert: Bool = false
    @State private var addTarget: CategoryTemplate? = nil
    @ObservedObject var categoryBudgetAmount = NumbersOnly()
    
    @State private var showRemoveConfirmAlert: Bool = false
    @State private var removeTarget: CategoryTemplate? = nil
    
    @State private var showCreateCategoryTemplateModalView: Bool = false

    @State private var tmpBudget: Budget = Budget(startDate: Date(), endDate: Date(), budgetAmount: 0)
    
    private var budgetCategories: [BudgetCategory.CategoryDisplayData] {
        self.tmpBudget.categories.map { category in
            let categoryTemplate = self.categoryTemplates.first { $0.id == category.categoryTemplateId }
            return BudgetCategory.CategoryDisplayData(
                title: categoryTemplate!.title,
                budgetAmount: category.budgetAmount,
                balanceAmount: 0,
                mainColor: categoryTemplate!.theme.mainColor,
                accentColor: categoryTemplate!.theme.accentColor,
                categoryTemplateId: categoryTemplate!.id
            )
        }
    }
    
    private var appendableCategoryTemplates: [CategoryTemplate] {
        self.categoryTemplates.filter { categoryTemplate in
            self.tmpBudget.categories.first { $0.categoryTemplateId == categoryTemplate.id } == nil
        }
    }
    
    private func addBudgetCategory() -> Void {
        if addTarget == nil {
            return
        }
        
        let budgetAmount: Int = Int(self.categoryBudgetAmount.value) ?? 0
        self.tmpBudget.categories.append(Category(categoryTemplateId: self.addTarget!.id, budgetAmount: budgetAmount))
    }
    
    private func resetAddAlert() {
        self.showAddConfirmAlert = false
        self.addTarget = nil
        self.categoryBudgetAmount.value = ""
    }
    
    private func removeBudgetCategory() -> Void {
        if let categoryTemplate = self.removeTarget {
            self.tmpBudget.categories = self.tmpBudget.categories.filter { $0.categoryTemplateId != categoryTemplate.id }
            self.tmpBudget.expenses = self.tmpBudget.expenses.map { expense in
                var tmp = expense
                if expense.categoryId == categoryTemplate.id {
                    tmp.categoryId = nil
                }
                return tmp
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                Text("\(self.tmpBudget.title)の予算へのカテゴリの追加, 削除")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.black.opacity(0))
                    .listRowInsets(EdgeInsets())
                Section(header: Text("追加済み")) {
                    if self.tmpBudget.categories.isEmpty {
                        Text("追加されているカテゴリはありません")
                            .listRowBackground(Color.black.opacity(0))
                            .font(.callout)
                    }
                    ForEach(self.budgetCategories, id: \.title) { category in
                        Button(role: .none) {
                            let categoryTemplate = self.categoryTemplates.first { $0.id == category.categoryTemplateId }
                            self.removeTarget = categoryTemplate
                            self.showRemoveConfirmAlert = true
                        } label: {
                            HStack {
                                HStack {
                                    CategoryTemplateLabel(title: category.title, mainColor: category.mainColor, accentColor: category.accentColor)
                                    Text("¥\(category.budgetAmount)")
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                                
                            }
                        }
                    }
                }
                Section(header: Text("カテゴリ一覧")) {
                    if self.categoryTemplates.isEmpty {
                        Text("カテゴリが登録されていません")
                            .listRowBackground(Color.black.opacity(0))
                            .font(.callout)
                    }
                    if self.appendableCategoryTemplates.isEmpty {
                        Text("追加可能なカテゴリがありません")
                            .listRowBackground(Color.black.opacity(0))
                            .font(.callout)
                    }
                    ForEach(self.appendableCategoryTemplates) { categoryTemplate in
                        Button(role: .none) {
                            self.showAddConfirmAlert = true
                            self.addTarget = categoryTemplate
                        } label: {
                            HStack {
                                CategoryTemplateLabel(title: categoryTemplate.title, mainColor: categoryTemplate.theme.mainColor, accentColor: categoryTemplate.theme.accentColor)
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button {
                        self.showCreateCategoryTemplateModalView = true
                    } label: {
                        Text("新しいカテゴリを作成")
                    }
                    .buttonStyle(.borderless)
                    Spacer()
                }
                .listRowBackground(Color.black.opacity(0))
                .listRowSeparator(.hidden)
                
                AddBudgetCategoryAlert(
                    textfieldText: self.$categoryBudgetAmount.value,
                    showingAlert: self.$showAddConfirmAlert,
                    budgetTitle: self.tmpBudget.title,
                    categoryTitle: self.addTarget?.title ?? "",
                    cancelButtonAction: {
                        self.resetAddAlert()
                    },
                    addButtonAction: {
                        self.addBudgetCategory()
                        self.resetAddAlert()
                    }
                )
                .listRowBackground(Color.black.opacity(0))
            }
            .navigationTitle("カテゴリの追加 削除")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.showModalView = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("完了") {
                        self.budget = self.tmpBudget
                        self.showModalView = false
                    }
                }
            }
            .onAppear {
                self.tmpBudget = self.budget
                if #available(iOS 15, *) {
                    UITableView.appearance().contentInset.top = -25
                }
            }
            .onDisappear {
                if #available(iOS 15, *) {
                    UITableView.appearance().contentInset.top = .zero
                }
            }
            .alert("カテゴリの削除", isPresented: self.$showRemoveConfirmAlert) {
                Button("削除", role: .destructive) {
                    self.removeBudgetCategory()
                    self.showRemoveConfirmAlert = false
                    self.removeTarget = nil
                }
            } message: {
                if self.removeTarget == nil {
                    Text("エラー")
                }
                Text("\(self.tmpBudget.title)から\(self.removeTarget?.title ?? "")カテゴリを削除しますか？削除したカテゴリに紐づく出費は未分類になります。")
            }
            .sheet(isPresented: self.$showCreateCategoryTemplateModalView) {
                CreateCategoryTemplateModalView(showModalView: self.$showCreateCategoryTemplateModalView) { categoryTemplate in
                    self.categoryTemplates.append(categoryTemplate)
                }
            }
        }
    }
}

struct CreateBudgetCategoryModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditBudgetCategoryModalView(
            showModalView: .constant(true),
            budget: .constant(Budget.sampleData[0]),
            categoryTemplates: .constant(CategoryTemplate.sampleData)
        )
    }
}
