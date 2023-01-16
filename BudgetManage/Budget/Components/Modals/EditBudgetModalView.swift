//
//  EditBudgetModalView.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2022/10/24.
//

import SwiftUI

struct EditBudgetModalView: View {
    @Environment(\.dismiss) private var dismiss

    @State var currentBudget: BudgetCD?
    var onSave: (_ budget: BudgetCD) -> Void
    
    @State private var title: String = ""
    @ObservedObject private var amount = NumbersOnly()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            return (
                self.currentBudget?.title != self.title ||
                self.currentBudget?.budgetAmount != Int32(self.amount.value) ?? 0 ||
                self.currentBudget?.startDate != self.startDate ||
                self.currentBudget?.endDate != self.endDate
            )
        }
    }
    
    private func commit() {
        if let budget = self.currentBudget {
            budget.title = self.title
            budget.budgetAmount = Int32(self.amount.value) ?? 0
            budget.startDate = self.startDate
            budget.endDate = self.endDate
            self.onSave(budget)
        }
        self.dismiss()
    }
    
    var body: some View {
        List {
            Section(header: Text("タイトル")) {
                TextField("今月の予算", text: self.$title)
                    .modifier(TextFieldClearButton(text: self.$title))
            }
            Section(header: Text("期間")) {
                DatePicker(selection: self.$startDate, displayedComponents: .date) {
                    Text("開始日")
                        .foregroundColor(.secondary)
                }
                DatePicker(selection: self.$endDate, displayedComponents: .date) {
                    Text("終了日")
                        .foregroundColor(.secondary)
                }
            }
            Section(header: Text("予算額")) {
                AmountTextField(value: self.$amount.value)
            }
        }
        .navigationTitle("予算の編集")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(isModified: self.isModified) {
            self.commit()
        }
        .onAppear {
            if let budget = self.currentBudget {
                self.title = budget.title ?? ""
                self.amount.value = String(budget.budgetAmount)
                self.startDate = budget.startDate ?? Date()
                self.endDate = budget.endDate ?? Date()
            }
        }
    }
}

