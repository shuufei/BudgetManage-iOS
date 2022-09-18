//
//  EditBudgetCategoryDetailModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/18.
//

import SwiftUI

struct EditBudgetCategoryDetailModalView: View {
    @Binding var budget: Budget
    @Binding var selectedCategoryId: UUID?
    @Binding var showModalView: Bool
    @Binding var categoryTemplates: [CategoryTemplate]
    
    @State private var categoryTemplateId: UUID = UUID()
    @State private var budgetAmount = NumbersOnly()
    
    @State private var initialized: Bool = false
    
    private func update() {
        let index = self.budget.categories.firstIndex { $0.id == self.selectedCategoryId }
        if index == nil {
            return
        }
        if let budgetAmountValue = Int(self.budgetAmount.value) {
            self.budget.categories[index!].budgetAmount = budgetAmountValue
            self.budget.categories[index!].categoryTemplateId = self.categoryTemplateId
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("予算額")) {
                    HStack {
                        Text("¥")
                        TextField("予算額", text: self.$budgetAmount.value)
                    }
                }
                Section(header: Text("カテゴリ")) {
                    Picker("カテゴリを選択", selection: self.$categoryTemplateId) {
                        ForEach(self.categoryTemplates) { categoryTemplate in
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
                if let category = self.budget.categories.first(where: { $0.id == self.selectedCategoryId }) {
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
            budget: .constant(Budget.sampleData[0]), selectedCategoryId: .constant(Budget.sampleData[0].categories[0].id), showModalView: .constant(true), categoryTemplates: .constant(CategoryTemplate.sampleData))
    }
}
