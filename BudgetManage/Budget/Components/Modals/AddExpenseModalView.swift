//
//  AddExpenseModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import SwiftUI

fileprivate struct AppendExpenseButton: View {
    let amount: Int
    let action: () -> Void
    var body: some View {
        Button {
            self.action()
        } label: {
            Label("¥\(self.amount)", systemImage: "plus")
                .frame(maxWidth: .infinity)
        }
    }
}

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
                    HStack {
                        AmountTextField(value: self.$amount.value)
                    }
                    VStack {
                        HStack {
                            AppendExpenseButton(amount: 10000) {
                                if let current = Int(amount.value) {
                                    self.amount.value =  String(current + 10000)
                                } else {
                                    self.amount.value = String(10000)
                                }
                            }
                            AppendExpenseButton(amount: 5000) {
                                if let current = Int(amount.value) {
                                    self.amount.value =  String(current + 5000)
                                } else {
                                    self.amount.value = String(5000)
                                }
                            }
                        }
                        HStack {
                            AppendExpenseButton(amount: 1000) {
                                if let current = Int(amount.value) {
                                    self.amount.value =  String(current + 1000)
                                } else {
                                    self.amount.value = String(1000)
                                }
                            }
                            AppendExpenseButton(amount: 500){
                                if let current = Int(amount.value) {
                                    self.amount.value =  String(current + 500)
                                } else {
                                    self.amount.value = String(500)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .buttonStyle(.bordered)
                    .tint(.blue)
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
            .navigationTitle("出費")
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
