//
//  AddExpenseView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    var categoryId: UUID?
    var onAdd: () -> Void
    
    @ObservedObject private var amount = NumbersOnly()
    @State private var expenseDate = Date()
    @State private var memo = ""
    @State private var includeTime: Bool = true
    
    private var theme: Theme? {
        if let category = self.budgetStore.selectedBudget?.categories.first(where: { category in category.id == self.categoryId }), let categoryTemplate = self.categoryTemplateStore.categories.first(where: { categoryTemplate in categoryTemplate.id == category.categoryTemplateId }) {
            return categoryTemplate.theme
        }
        return nil
    }
    
    private func add() {
        let amount = Int(self.amount.value) ?? 0;
        if var budget = self.budgetStore.selectedBudget {
            budget.expenses.append(
                Expense(
                    date: self.expenseDate,
                    amount: amount,
                    categoryId: self.categoryId,
                    memo: self.memo,
                    includeTimeInDate: self.includeTime
                )
            )
            self.budgetStore.selectedBudget = budget
        }
        self.onAdd()
    }
    var body: some View {
        List {
            Section(header: Text("金額")) {
                AmountTextField(value: self.$amount.value, theme: self.theme)
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
            .tint(self.theme?.mainColor ?? .blue)
            .listRowBackground(Color.red.opacity(0))
            .listRowInsets(EdgeInsets())
        }
    }
}
//
struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(onAdd: {})
            .environmentObject(BudgetStore())
            .environmentObject(CategoryTemplateStore())
    }
}
