//
//  EditExpenseModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/01.
//

import SwiftUI

struct EditExpenseModalView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var amount = NumbersOnly()
    
    var expense: Expense
    var onSave: (_ expense: Expense) -> Void
    
    @State var data: Expense = Expense(date: Date(), amount: 0)

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("金額")) {
                    AmountTextField(value: self.$amount.value)
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
                    TextField("メモ", text: self.$data.memo)
                        .modifier(TextFieldClearButton(text: self.$data.memo))
                }
            }
            .navigationTitle("出費の編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("保存") {
                        self.data.amount = Int(self.amount.value) ?? 0
                        onSave(self.data)
                        self.dismiss()
                    }
                }
            }
            .onAppear {
                self.amount.value = String(self.expense.amount)
                self.data = self.expense
            }
        }
    }
}

struct EditExpenseModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditExpenseModalView(expense: Expense.sampleData[0]) { _ in }
    }
}
