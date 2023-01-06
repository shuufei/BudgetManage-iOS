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
    
    var body: some View {
        NavigationView {
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル", role: .cancel) {
                        if self.isModified {
                            presentingConfirmationDialog.toggle()
                        }
                        else {
                            self.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("保存") {
                        self.data.budgetAmount = Int(self.amount.value) ?? 0
                        onSave(self.data)
                        self.dismiss()
                    }
                }
            }
            .onAppear {
                self.amount.value = String(self.budget.budgetAmount)
                self.data = self.budget
            }
        }
        .interactiveDismissDisabled(isModified, attemptToDismiss: self.$presentingConfirmationDialog)
        .confirmationDialog("", isPresented: $presentingConfirmationDialog) {
            Button("変更を破棄", role: .destructive, action: {
                self.dismiss()
            })
            Button("キャンセル", role: .cancel, action: { })
        } message: {
            Text("保存されていない変更があります")
        }
    }
}

