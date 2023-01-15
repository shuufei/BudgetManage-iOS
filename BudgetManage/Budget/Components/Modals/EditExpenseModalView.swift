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
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>
    
    var expense: ExpenseCD
    var onSave: (_ expense: ExpenseCD) -> Void

//    @State private var selectedCategoryId: UUID?
//    @State private var data: Expense = Expense(date: Date(), amount: 0)
    @State private var initialized: Bool = false
    
    @ObservedObject private var amount = NumbersOnly()
    @State private var memo: String = ""
    @State private var date: Date = Date()
    @State private var includeTimeInDate: Bool = false
    @State private var budgetCategoryId: UUID? = nil
    
//    private var theme: Theme? {
//        if let category = self.budgetStore.selectedBudget?.categories.first(where: { category in category.id == self.selectedCategoryId }), let categoryTemplate = self.categoryTemplateStore.categories.first(where: { categoryTemplate in categoryTemplate.id == category.categoryTemplateId }) {
//            return categoryTemplate.theme
//        }
//        return nil
//    }
    
    private var selectedBudgetCategoryMainColor: Color? {
        (self.uiStateEntities.first?.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first { budgetCategory in
            budgetCategory.id == self.budgetCategoryId
        }?.mainColor
    }
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            return (
                self.expense.amount != Int32(self.amount.value) ||
                self.expense.memo != self.memo ||
                self.expense.date != self.date ||
                self.expense.includeTimeInDate != self.includeTimeInDate ||
                self.expense.budgetCategory?.id != self.budgetCategoryId
            )
        }
    }
    
    private func commit() {
//        TODO: update処理
        onSave(self.expense)
        self.dismiss()
    }

    var body: some View {
        List {
//            Section(header: Text("金額")) {
//                AmountTextField(value: self.$amount.value, mainColor: self.selectedBudgetCategoryMainColor)
//                //                    .onChange(of: self.amount.value, perform: { value in
//                //                        self.data.amount = Int(self.amount.value) ?? 0
//                //                    })
//            }
            Section(header: Text("出費日")) {
                DatePicker("日時", selection: self.$date, displayedComponents: self.includeTimeInDate ? [.date, .hourAndMinute] : .date)
                    .foregroundColor(.secondary)
                Toggle(isOn: self.$includeTimeInDate) {
                    Text("時間を含める")
                        .foregroundColor(.secondary)
                }
            }
            Section {
                BudgetCategoryPicker(selectedBudgetCategoryId: self.$budgetCategoryId)
                //                    .onChange(of: self.selectedCategoryId, perform: { value in
                //                        self.data.categoryId = self.selectedCategoryId
                //                    })
                TextField("メモ", text: self.$memo)
                    .modifier(TextFieldClearButton(text: self.$memo))
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
            //            self.data = self.expense
            self.amount.value = String(self.expense.amount)
            self.memo = self.expense.memo ?? ""
            self.date = self.expense.date ?? Date()
            self.includeTimeInDate = self.expense.includeTimeInDate
            self.budgetCategoryId = self.expense.budgetCategory?.id
            //            self.selectedCategoryId = self.expense.categoryId
            self.initialized = true
        }
    }
}
