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
    @Environment(\.colorScheme) private var colorScheme

    @FetchRequest(entity: CategoryTemplateCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)]) private var categoryTemplates: FetchedResults<CategoryTemplateCD>
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>

    @ObservedObject var categoryBudgetAmount = NumbersOnly()

    @State private var showAddConfirmAlert: Bool = false
    @State private var addTarget: CategoryTemplateCD? = nil
    @State private var showRemoveConfirmAlert: Bool = false
    @State private var removeTarget: BudgetCategoryCD? = nil
    @State private var showCreateCategoryTemplateModalView: Bool = false
    
    private var budgetCategories: [BudgetCategoryCD] {
        return (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD] ?? []).filter { $0.title != "未分類" }
    }

    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    private var appendableCategoryTemplates: [CategoryTemplateCD] {
        self.categoryTemplates.filter { template in
            let budgetCategories = (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD]) ?? []
            return budgetCategories.first { budgetCategory in
                return budgetCategory.categoryTemplate?.id == template.id
            } == nil
        }
    }
    
    private func addBudgetCategory() -> Void {
        if addTarget == nil {
            return
        }

        let newBudgetCategory = BudgetCategoryCD(context: self.viewContext)
        newBudgetCategory.id = UUID()
        newBudgetCategory.createdAt = Date()
        newBudgetCategory.expenses = []
        newBudgetCategory.categoryTemplate = self.addTarget
        newBudgetCategory.budgetAmount = Int32(self.categoryBudgetAmount.value) ?? 0
        self.activeBudget?.addToBudgetCategories(newBudgetCategory)
        if let uncategorized = self.activeBudget?.uncategorizedBudgetCategory {
            uncategorized.budgetAmount -= newBudgetCategory.budgetAmount
        }
        self.uiStateEntities.first?.updatedAt = Date()
    }
    
    private func removeBudgetCategory() -> Void {
        if let budgetCategory = self.removeTarget {
            if let uncategorized = self.activeBudget?.uncategorizedBudgetCategory {
                (budgetCategory.expenses?.allObjects as? [ExpenseCD])?.forEach { expense in
                    expense.budgetCategory = uncategorized
                }
                uncategorized.budgetAmount += budgetCategory.budgetAmount
            }
            self.viewContext.delete(budgetCategory)
            self.uiStateEntities.first?.updatedAt = Date()
        }
    }

    private func resetAddAlert() {
        self.showAddConfirmAlert = false
        self.addTarget = nil
        self.categoryBudgetAmount.value = ""
    }
    
    private func commit() {
        try? self.viewContext.save()
        self.dismiss()
    }
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            self.viewContext.hasChanges
        }
    }

    var body: some View {
        List {
            Text("\(self.activeBudget?.title ?? "")の予算へのカテゴリの追加, 削除")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.black.opacity(0))
                .listRowInsets(EdgeInsets())
            Section(header: Text("追加済み")) {
                if self.budgetCategories.isEmpty {
                    Text("追加されているカテゴリはありません")
                        .listRowBackground(Color.black.opacity(0))
                        .font(.callout)
                }
                ForEach(Array(self.budgetCategories.enumerated()), id: \.element) { index, category in
                    Button(role: .none) {
                        self.removeTarget = category
                        self.showRemoveConfirmAlert = true
                    } label: {
                        HStack {
                            HStack {
                                CategoryTemplateLabel(title: category.title, mainColor: category.mainColor ?? category.getUncategorizedMainColor(self.colorScheme), accentColor: category.accentColor)
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
                            CategoryTemplateLabel(title: categoryTemplate.title ?? "", mainColor: categoryTemplate.theme.mainColor, accentColor: categoryTemplate.theme.accentColor)
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
                budgetTitle: self.activeBudget?.title ?? "",
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
            Text("\(self.activeBudget?.title ?? "")から\(self.removeTarget?.title ?? "")カテゴリを削除しますか？削除したカテゴリに紐づく出費は未分類になります。")
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
        .confirmationDialog(isModified: self.isModified, onCancel: {
            self.viewContext.rollback()
        }, onCommit: self.commit)
    }
}
