//
//  CreateBudgetCategoryModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import SwiftUI

struct EditBudgetCategoryModalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @FetchRequest(entity: CategoryTemplateCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)]) private var categoryTemplates: FetchedResults<CategoryTemplateCD>
    
    @State private var showAddConfirmAlert: Bool = false
    @State private var addTarget: CategoryTemplate? = nil
    @ObservedObject var categoryBudgetAmount = NumbersOnly()

    @State private var showRemoveConfirmAlert: Bool = false
    @State private var removeTarget: CategoryTemplate? = nil
    
    @State private var showCreateCategoryTemplateModalView: Bool = false

    @State private var tmpBudget: Budget = Budget(startDate: Date(), endDate: Date(), budgetAmount: 0)
    
    private var budgetCategories: [BudgetCategory.CategoryDisplayData] {
        return getBudgetCategorieDisplayDataList(categories: self.tmpBudget.categories, categoryTemplates: self.categoryTemplateStore.categories)
    }
    
    private var appendableCategoryTemplates: [CategoryTemplate] {
        self.categoryTemplateStore.categories.filter { categoryTemplate in
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
        if let categoryTemplate = self.removeTarget, let category = self.tmpBudget.categories.first(where: { $0.categoryTemplateId == categoryTemplate.id }) {
            self.tmpBudget.categories = self.tmpBudget.categories.filter { $0.categoryTemplateId != categoryTemplate.id }
            self.tmpBudget.expenses = self.tmpBudget.expenses.map { expense in
                var tmp = expense
                if expense.categoryId == category.id {
                    tmp.categoryId = nil
                }
                return tmp
            }
        }
    }
    
    private func commit() {
        self.budgetStore.selectedBudget = self.tmpBudget
        self.dismiss()
    }
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            self.budgetStore.selectedBudget != self.tmpBudget
        }
    }

    var body: some View {
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
                ForEach(Array(self.budgetCategories.enumerated()), id: \.element) { index, category in
                    Button(role: .none) {
                        let categoryTemplate = self.categoryTemplateStore.categories.first { $0.id == category.categoryTemplateId }
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
                if self.categoryTemplateStore.categories.isEmpty {
                    Text("カテゴリが登録されていません")
                        .listRowBackground(Color.black.opacity(0))
                        .font(.callout)
                } else if self.appendableCategoryTemplates.isEmpty {
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
        .navigationTitle("予算のカテゴリ編集")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let budget = self.budgetStore.selectedBudget {
                self.tmpBudget = budget
            }
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
            CreateCategoryTemplateModalView() { categoryTemplate in
                let newCategoryTemplate = CategoryTemplateCD(context: self.viewContext)
                newCategoryTemplate.id = categoryTemplate.id
                newCategoryTemplate.title = categoryTemplate.title
                newCategoryTemplate.themeName = categoryTemplate.theme.name
                newCategoryTemplate.createdAt = Date()
                try? self.viewContext.save()
            }
        }
        .confirmationDialog(isModified: self.isModified, onCommit: self.commit)
    }
}

struct CreateBudgetCategoryModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditBudgetCategoryModalView()
            .environmentObject(BudgetStore())
            .environmentObject(CategoryTemplateStore())
    }
}
