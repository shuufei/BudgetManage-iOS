//
//  EditBudgetCategoryDetailModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/18.
//

import SwiftUI

struct EditBudgetCategoryDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    @Binding var selectedCategoryId: UUID?
    
    @State private var categoryTemplateId: UUID = UUID()
    @ObservedObject private var budgetAmount = NumbersOnly()
    @State private var current: Category = Category(categoryTemplateId: UUID(), budgetAmount: 0)
    @State private var data: Category = Category(categoryTemplateId: UUID(), budgetAmount: 0)
    @State private var initialized: Bool = false
    
    private func update() {
        if let budget = self.budgetStore.selectedBudget {
            let index = budget.categories.firstIndex { $0.id == self.selectedCategoryId }
            if index == nil {
                return
            }
            if let budgetAmountValue = Int(self.budgetAmount.value) {
                var tmpBudget = budget
                tmpBudget.categories[index!].budgetAmount = budgetAmountValue
                tmpBudget.categories[index!].categoryTemplateId = self.categoryTemplateId
                self.budgetStore.selectedBudget = tmpBudget
            }
        }
    }
    
    private func commit() {
        self.update()
        self.dismiss()
    }
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            self.current != self.data
        }
    }

    var body: some View {
        List {
            Section(header: Text("予算額")) {
                AmountTextField(value: self.$budgetAmount.value)
                    .onChange(of: self.budgetAmount.value, perform: { value in
                        self.data.budgetAmount = Int(self.budgetAmount.value) ?? 0
                    })
            }
            Section(header: Text("カテゴリ")) {
                Picker("カテゴリを選択", selection: self.$categoryTemplateId) {
                    ForEach(self.categoryTemplateStore.categories) { categoryTemplate in
                        CategoryTemplateLabel(title: categoryTemplate.title, mainColor: categoryTemplate.theme.mainColor, accentColor: categoryTemplate.theme.accentColor)
                    }
                }.onChange(of: self.categoryTemplateId, perform: { value in
                    self.data.categoryTemplateId = value
                })
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
            if let budget = self.budgetStore.selectedBudget, let category = budget.categories.first(where: { $0.id == self.selectedCategoryId }) {
                self.categoryTemplateId = category.categoryTemplateId
                self.budgetAmount.value = String(category.budgetAmount)
                self.current = category
                self.data = category
            }
            self.initialized = true
        }
        .confirmationDialog(isModified: self.isModified, onCommit: self.commit)
    }
}

struct EditBudgetCategoryDetailModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditBudgetCategoryDetailModalView(
            selectedCategoryId: .constant(Budget.sampleData[0].categories[0].id)
        )
            .environmentObject(BudgetStore())
            .environmentObject(CategoryTemplateStore())
    }
}
