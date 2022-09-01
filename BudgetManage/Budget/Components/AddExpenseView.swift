//
//  AddExpenseView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI

struct AddExpenseView: View {
    @Binding var budget: Budget
    var onAdd: () -> Void
    
    @ObservedObject private var amount = NumbersOnly()
    @State private var expenseDate = Date()
    @State private var memo = ""
    @State private var includeTime: Bool = true
    
    private func add() {
        let amount = Int(self.amount.value) ?? 0;
        self.budget.expenses.append(
            Expense(
                date: self.expenseDate, amount: amount, categoryId: nil, memo: self.memo, includeTimeInDate: self.includeTime
            )
        )
        self.onAdd()
    }
    var body: some View {
        List {
            Section(header: Text("金額")) {
                AmountTextField(value: self.$amount.value)
            }
            Section(header: Text("出費日")) {
                DatePicker("日時", selection: self.$expenseDate, displayedComponents: self.includeTime ? [.date, .hourAndMinute] : .date)
                    .foregroundColor(.secondary)
                Toggle(isOn: self.$includeTime) {
                    Text("時間を含める")
                        .foregroundColor(.secondary)
                }
            }
            Section {
                TextField("メモ", text: self.$memo)
                    .modifier(TextFieldClearButton(text: self.$memo))
            }
            Button {
                self.add()
            } label: {
                HStack(alignment: .center) {
                    Image(systemName: "plus")
                    Text("追加")
                        .padding(.vertical, 4)
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(self.amount.value.isEmpty)
            .buttonStyle(.borderedProminent)
            .listRowBackground(Color.red.opacity(0))
            .listRowInsets(EdgeInsets())
        }
    }
}
//
struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(budget: .constant(Budget.sampleData[0]), onAdd: {})
    }
}
