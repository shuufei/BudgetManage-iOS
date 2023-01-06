//
//  EditExpenseModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/01.
//

import SwiftUI

struct EditExpenseModalView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @ObservedObject private var amount = NumbersOnly()
    
    var expense: Expense
    var onSave: (_ expense: Expense) -> Void

    @State private var selectedCategoryId: UUID?
    @State private var data: Expense = Expense(date: Date(), amount: 0)
    @State private var initialized: Bool = false
    
    private var theme: Theme? {
        if let category = self.budgetStore.selectedBudget?.categories.first(where: { category in category.id == self.selectedCategoryId }), let categoryTemplate = self.categoryTemplateStore.categories.first(where: { categoryTemplate in categoryTemplate.id == category.categoryTemplateId }) {
            return categoryTemplate.theme
        }
        return nil
    }
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            self.expense != self.data
        }
    }
    
    private func commit() {
        onSave(self.data)
        self.dismiss()
    }

    var body: some View {
        List {
            Section(header: Text("金額")) {
                AmountTextField(value: self.$amount.value, theme: self.theme)
                    .onChange(of: self.amount.value, perform: { value in
                        self.data.amount = Int(self.amount.value) ?? 0
                    })
            }
            Section(header: Text("出費日")) {
                DatePicker("日時", selection: self.$data.date, displayedComponents: self.data.includeTimeInDate ? [.date, .hourAndMinute] : .date)
                    .foregroundColor(.secondary)
                Toggle(isOn: self.$data.includeTimeInDate) {
                    Text("時間を含める")
                        .foregroundColor(.secondary)
                }
            }
            Section {
                BudgetCategoryPicker(selectedCategoryId: self.$selectedCategoryId)
                    .onChange(of: self.selectedCategoryId, perform: { value in
                        self.data.categoryId = self.selectedCategoryId
                    })
                TextField("メモ", text: self.$data.memo)
                    .modifier(TextFieldClearButton(text: self.$data.memo))
            }
        }
        .navigationTitle("出費の編集")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(isModified: self.isModified, onCommit: self.commit)
        .onAppear {
            if self.initialized {
                return
            }
            self.amount.value = String(self.expense.amount)
            self.data = self.expense
            self.selectedCategoryId = self.expense.categoryId
            self.initialized = true
        }
    }
}
