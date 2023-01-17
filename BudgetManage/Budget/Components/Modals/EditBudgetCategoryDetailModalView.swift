//
//  EditBudgetCategoryDetailModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/18.
//

import SwiftUI

struct EditBudgetCategoryDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>
    @FetchRequest(entity: CategoryTemplateCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) private var categoryTemplates: FetchedResults<CategoryTemplateCD>

    @Binding var selectedCategoryId: UUID?
    
    @State private var categoryTemplateId: UUID = UUID()
    @ObservedObject private var budgetAmount = NumbersOnly()
    @State private var current: BudgetCategoryCD?
    @State private var initialized: Bool = false
    
    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    private var categoryTemplate: CategoryTemplateCD? {
        self.categoryTemplates.first { template in
            template.id == self.categoryTemplateId
        }
    }
    
    private func update() {
        self.current?.budgetAmount = Int32(self.budgetAmount.value) ?? 0
        self.current?.categoryTemplate = self.categoryTemplate
        self.uiStateEntities.first?.updatedAt = Date()
        try? self.viewContext.save()
    }
    
    private func commit() {
        self.update()
        self.dismiss()
    }
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            return (
                self.current?.budgetAmount != Int32(self.budgetAmount.value) ?? 0 ||
                self.current?.categoryTemplate?.id != self.categoryTemplateId
            )
        }
    }

    var body: some View {
        List {
            Section(header: Text("予算額")) {
                AmountTextField(value: self.$budgetAmount.value, mainColor: self.categoryTemplate?.theme.mainColor)
            }
            Section(header: Text("カテゴリ")) {
                Picker("カテゴリを選択", selection: self.$categoryTemplateId) {
                    ForEach(self.categoryTemplates) { categoryTemplate in
                        CategoryTemplateLabel(title: categoryTemplate.title ?? "", mainColor: categoryTemplate.theme.mainColor, accentColor: categoryTemplate.theme.accentColor)
                            .tag(categoryTemplate.id!)
                    }
                }
            }
        }
        .navigationTitle("予算カテゴリの編集")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if #available(iOS 15, *) {
                UITableView.appearance().contentInset.top = .zero
            }
            if self.initialized {
               return
            }
            if let budgetCategory = (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first(where: { $0.id == self.selectedCategoryId }) {
                if let id = budgetCategory.categoryTemplate?.id {
                    self.categoryTemplateId = id
                }
                self.budgetAmount.value = String(budgetCategory.budgetAmount)
                self.current = budgetCategory
            }
            self.initialized = true
        }
        .confirmationDialog(isModified: self.isModified, onCommit: self.commit)
    }
}
