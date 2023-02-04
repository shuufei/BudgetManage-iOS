//
//  CategoryListModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import SwiftUI
import CoreData

struct CategoryTemplateListModalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @FetchRequest(entity: CategoryTemplateCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)]) private var categoryTemplates: FetchedResults<CategoryTemplateCD>
    @FetchRequest(entity: BudgetCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) var budgets: FetchedResults<BudgetCD>
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>

    @Binding var showModalView: Bool

    @State private var showCreateCategoryTemplateModalView: Bool = false

    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: CategoryTemplateCD? = nil

    @State private var editTarget: CategoryTemplateCD? = nil

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
                            Text(categoryTemplate.title ?? "")
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
                CreateCategoryTemplateModalView() { categoryTemplate in
                    let newCategoryTemplate = CategoryTemplateCD(context: self.viewContext)
                    newCategoryTemplate.id = categoryTemplate.id
                    newCategoryTemplate.title = categoryTemplate.title
                    newCategoryTemplate.themeName = categoryTemplate.theme.name
                    newCategoryTemplate.createdAt = Date()
                    try? self.viewContext.save()
                }
            }
            .alert("カテゴリの削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.deletionTarget) { categoryTemplate in
                    Button("削除", role: .destructive) {
                        if let categoryTemplate = self.deletionTarget {
                            let fetchRequestExpense = NSFetchRequest<NSFetchRequestResult>()
                            fetchRequestExpense.entity = ExpenseCD.entity()
                            let expenses = try? self.viewContext.fetch(fetchRequestExpense) as? [ExpenseCD]
                            expenses?.forEach { expense in
                                if expense.budgetCategory?.categoryTemplate?.id == categoryTemplate.id {
                                    let uncategorized = expense.budget?.uncategorizedBudgetCategory
                                    expense.budgetCategory = uncategorized ?? nil
                                }
                            }
                            self.budgets.forEach { budget in
//                                削除したcategoryTemplateに紐づくbudgetCategoryを削除
                                let removedBudgetCategories = (budget.budgetCategories?.allObjects as? [BudgetCategoryCD])?.filter({
                                    $0.categoryTemplate?.id != categoryTemplate.id
                                }) ?? []
                                budget.budgetCategories = NSSet(array: removedBudgetCategories)
//                                budgetCategoryが増減したので、未分類の予算額を算出し直す
                                let budgetCategoriesAmount = (budget.budgetCategories?.allObjects as? [BudgetCategoryCD])?.reduce(0, {x, y in
                                    return x + (y.title != "未分類" ? y.budgetAmount : 0)
                                }) ?? 0
                                budget.uncategorizedBudgetCategory?.budgetAmount = budget.budgetAmount - budgetCategoriesAmount
                            }
                            self.uiStateEntities.first?.updatedAt = Date()
                            self.viewContext.delete(categoryTemplate)
                            try? self.viewContext.save()
                        }
                    }
            } message: { categoryTemplate in
                Text("カテゴリを削除しますか?\n削除したカテゴリが紐づいてる出費は未分類になります。")
            }
            .sheet(item: self.$editTarget) { editTarget in
                EditCategoryTemplateModalView(
                    categoryTemplate: editTarget
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
