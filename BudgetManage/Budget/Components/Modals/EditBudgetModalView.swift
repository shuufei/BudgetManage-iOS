//
//  EditBudgetModalView.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2022/10/24.
//

import SwiftUI

struct EditBudgetModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var amount = NumbersOnly()
    
    var budget: Budget
    var onSave: (_ budget: Budget) -> Void
    
    @State var data: Budget = Budget(title: "", startDate: Date(), endDate: Date(), budgetAmount: 0, isActibe: false, expenses: [])
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            self.budget != self.data
        }
    }
    
    private func commit() {
        self.data.budgetAmount = Int(self.amount.value) ?? 0
        onSave(self.data)
        self.dismiss()
    }
    
    var body: some View {
        List {
            Section(header: Text("タイトル")) {
                TextField("今月の予算", text: self.$data.title)
                    .modifier(TextFieldClearButton(text: self.$data.title))
            }
            Section(header: Text("期間")) {
                DatePicker(selection: self.$data.startDate, displayedComponents: .date) {
                    Text("開始日")
                        .foregroundColor(.secondary)
                }
                DatePicker(selection: self.$data.endDate, displayedComponents: .date) {
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
            self.amount.value = String(self.budget.budgetAmount)
            self.data = self.budget
        }
    }
}

