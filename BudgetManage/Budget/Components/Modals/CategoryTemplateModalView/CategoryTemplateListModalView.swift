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

    @Binding var showModalView: Bool

    @State private var showCreateCategoryTemplateModalView: Bool = false

    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: CategoryTemplateCD? = nil

    @State private var editTarget: CategoryTemplate? = nil

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
//                            self.editTarget = categoryTemplate
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
                                    expense.budgetCategory = nil
                                }
                            }
                            self.viewContext.delete(categoryTemplate)
                            try? self.viewContext.save()
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
