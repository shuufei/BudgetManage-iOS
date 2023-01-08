//
//  AddExpenseView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    var categoryId: UUID?
    var onAdd: () -> Void
    
    @ObservedObject private var amount = NumbersOnly()
    @State private var data: Expense = Expense(date: Date(), amount: 0)
    
    private var theme: Theme? {
        if let category = self.budgetStore.selectedBudget?.categories.first(where: { category in category.id == self.data.categoryId ?? self.categoryId }), let categoryTemplate = self.categoryTemplateStore.categories.first(where: { categoryTemplate in categoryTemplate.id == category.categoryTemplateId }) {
            return categoryTemplate.theme
        }
        return nil
    }
    
    private var budgetCategories: [BudgetCategory.CategoryDisplayData] {
        if let categories = self.budgetStore.selectedBudget?.categories {
            return getBudgetCategorieDisplayDataList(categories: categories, categoryTemplates: self.categoryTemplateStore.categories)
        }
        return []
    }
    
    private func add() {
        if var budget = self.budgetStore.selectedBudget {
            budget.expenses.append(
                self.data
            )
            self.budgetStore.selectedBudget = budget
        }
        self.onAdd()
    }
    
    var body: some View {
        List {
            Section(header: Text("金額")) {
                AmountTextField(value: self.$amount.value, theme: self.theme)
                    .onChange(of: self.amount.value, perform: { value in
                        self.data.amount = Int(value) ?? 0
                    })
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
                if self.categoryId == nil{
                    BudgetCategoryPicker(selectedCategoryId: self.$data.categoryId)
                }
                TextField("メモ", text: self.$data.memo)
                    .modifier(TextFieldClearButton(text: self.$data.memo))
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
            .tint(self.theme?.mainColor != nil ? self.theme?.mainColor : self.colorScheme == .dark ? .white : .black)
            .foregroundColor(self.colorScheme == .dark ? .black : .white)
            .listRowBackground(Color.red.opacity(0))
            .listRowInsets(EdgeInsets())
            .onAppear {
                self.data.categoryId = self.categoryId
            }
        }
    }
}
