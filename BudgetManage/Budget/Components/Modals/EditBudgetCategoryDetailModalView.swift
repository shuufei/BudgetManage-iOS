//
//  EditBudgetCategoryDetailModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/18.
//

import SwiftUI

struct EditBudgetCategoryDetailModalView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    @Binding var selectedCategoryId: UUID?
    @Binding var showModalView: Bool
    
    @State private var categoryTemplateId: UUID = UUID()
    @ObservedObject private var budgetAmount = NumbersOnly()
    
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

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("予算額")) {
                    AmountTextField(value: self.$budgetAmount.value)
                }
                Section(header: Text("カテゴリ")) {
                    Picker("カテゴリを選択", selection: self.$categoryTemplateId) {
                        ForEach(self.categoryTemplateStore.categories) { categoryTemplate in
                            CategoryTemplateLabel(title: categoryTemplate.title, mainColor: categoryTemplate.theme.mainColor, accentColor: categoryTemplate.theme.accentColor)
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
                if let budget = self.budgetStore.selectedBudget, let category = budget.categories.first(where: { $0.id == self.selectedCategoryId }) {
                    self.categoryTemplateId = category.categoryTemplateId
                    self.budgetAmount.value = String(category.budgetAmount)
                }
                self.initialized = true
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.showModalView = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("保存") {
                        self.update()
                        self.showModalView = false
                    }
                }
            }
        }
    }
}

struct EditBudgetCategoryDetailModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditBudgetCategoryDetailModalView(
            selectedCategoryId: .constant(Budget.sampleData[0].categories[0].id),
            showModalView: .constant(true)
        )
            .environmentObject(BudgetStore())
            .environmentObject(CategoryTemplateStore())
    }
}
