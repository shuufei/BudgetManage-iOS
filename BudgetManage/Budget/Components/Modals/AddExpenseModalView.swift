//
//  AddExpenseModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import SwiftUI

struct AddExpenseModalView: View {
    @Binding var showModalView: Bool
    @Binding var currentBudget: Budget
    @ObservedObject var amount = NumbersOnly()
    
    @State private var expenseDate = Date()
    @State private var memo = ""
    
    private func add() {
        let amount = Int(self.amount.value) ?? 0;
        self.currentBudget.expenses.append(
            Expense(
                date: self.expenseDate, amount: amount, categoryId: nil, memo: self.memo
            )
        )
        self.showModalView = false
    }
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("登録")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.showModalView = false
                    }
                }
            }
        }
    }
}

struct AddExpenseModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseModalView(showModalView: .constant(false), currentBudget: .constant(Budget.sampleData[0]))
    }
}
