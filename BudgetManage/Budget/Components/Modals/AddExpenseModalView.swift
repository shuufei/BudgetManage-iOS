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
            AddExpenseView(budget: self.$currentBudget) {
                self.showModalView = false
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
