//
//  EditExpenseModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/01.
//

import SwiftUI

struct EditExpenseModalView: View {
    var expense: ExpenseCD

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>

    @State private var initialized: Bool = false
    @ObservedObject private var amount = NumbersOnly()
    @State private var memo: String = ""
    @State private var date: Date = Date()
    @State private var includeTimeInDate: Bool = false
    @State private var budgetCategoryId: UUID? = nil
    
    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    private var selectedBudgetCategory: BudgetCategoryCD? {
        (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first { budgetCategory in
            budgetCategory.id == self.budgetCategoryId
        }
    }
    
    private var selectedBudgetCategoryMainColor: Color? {
        self.selectedBudgetCategory?.mainColor
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
        self.expense.amount = Int32(self.amount.value) ?? 0
        self.expense.memo = self.memo
        self.expense.date = self.date
        self.expense.includeTimeInDate = self.includeTimeInDate
        self.expense.budgetCategory = self.selectedBudgetCategory
        self.uiStateEntities.first?.updatedAt = Date()
        try? self.viewContext.save()
        
        self.dismiss()
    }

    var body: some View {
        List {
            Section(header: Text("金額")) {
                AmountTextField(value: self.$amount.value, mainColor: self.selectedBudgetCategoryMainColor)
            }
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
                TextField("メモ", text: self.$memo)
                    .modifier(TextFieldClearButton(text: self.$memo))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("出費の編集")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(isModified: self.isModified, onCommit: self.commit)
        .onAppear {
            if self.initialized {
                return
            }
            self.amount.value = String(self.expense.amount)
            self.memo = self.expense.memo ?? ""
            self.date = self.expense.date ?? Date()
            self.includeTimeInDate = self.expense.includeTimeInDate
            self.budgetCategoryId = self.expense.budgetCategory?.id

            self.initialized = true
        }
    }
}
