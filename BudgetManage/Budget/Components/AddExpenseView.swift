//
//  AddExpenseView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI

struct AddExpenseView: View {
    @Binding var budget: Budget
    @ObservedObject var amount = NumbersOnly()
    
    @State private var expenseDate = Date()
    @State private var memo = ""
    
    var onAdd: () -> Void
    
    private func add() {
        let amount = Int(self.amount.value) ?? 0;
        self.budget.expenses.append(
            Expense(
                date: self.expenseDate, amount: amount, categoryId: nil, memo: self.memo
            )
        )
        self.onAdd()
    }
    var body: some View {
        List {
            Section(header: Text("金額")) {
                AmountTextField(value: self.$amount.value)
            }
            Section {
                DatePicker(selection: self.$expenseDate, displayedComponents: .date) {
                    Text("出費日")
                }
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

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(budget: .constant(Budget.sampleData[0]), onAdd: {})
    }
}
