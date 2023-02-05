//
//  AddExpenseView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI
import CoreData

struct AddExpenseView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>

    var currentBudgetCategoryId: UUID?
    var onAdd: () -> Void

    @ObservedObject private var amount = NumbersOnly()
    @State private var memo: String = ""
    @State private var date: Date = Date()
    @State private var includeTimeInDate: Bool = false
    @State private var budgetCategoryId: UUID? = nil

    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    private var selectedBudgetCategoryMainColor: Color? {
        (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first { budgetCategory in
            budgetCategory.id == self.budgetCategoryId
        }?.mainColor
    }
    
    private func add() {
        if let ui = self.uiStateEntities.first {
            let newExpense = ExpenseCD(context: self.viewContext)
            newExpense.id = UUID()
            newExpense.amount = Int32(self.amount.value)  ?? 0
            newExpense.date = self.date
            newExpense.memo = self.memo
            newExpense.includeTimeInDate = self.includeTimeInDate
            newExpense.budget = ui.activeBudget
            (ui.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first {
                $0.id == self.budgetCategoryId
            }?.addToExpenses(newExpense)
            ui.activeBudget?.addToExpenses(newExpense)
            ui.updatedAt = Date()
            try? self.viewContext.save()
        } else {
            fatalError("unexpected state: activeBudget is undefined")
        }
        
        self.onAdd()
    }
    
    var body: some View {
        List {
            Section(header: Text("金額")) {
                AmountTextField(value: self.$amount.value, mainColor: self.selectedBudgetCategoryMainColor)
//                    .onChange(of: self.amount.value, perform: { value in
//                        self.data.amount = Int(value) ?? 0
//                    })
            }
            Section(header: Text("出費日")) {
                DatePicker("日時", selection: self.$date, displayedComponents: self.includeTimeInDate ? [.date, .hourAndMinute] : .date)
                    .foregroundColor(.secondary)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                Toggle(isOn: self.$includeTimeInDate) {
                    Text("時間を含める")
                        .foregroundColor(.secondary)
                }
            }
            Section {
                BudgetCategoryPicker(selectedBudgetCategoryId: self.$budgetCategoryId)
//                BudgetCategoryPicker(selectedCategoryId: self.$data.categoryId)
//                if self.categoryId == nil{
//                }
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
            .tint(self.selectedBudgetCategoryMainColor != nil ? self.selectedBudgetCategoryMainColor : self.colorScheme == .dark ? .white : .black)
            .foregroundColor(self.colorScheme == .dark ? .black : .white)
            .listRowBackground(Color.red.opacity(0))
            .listRowInsets(EdgeInsets())
            .onAppear {
//                self.data.categoryId = self.currentBudgetCategoryId
                self.budgetCategoryId = self.currentBudgetCategoryId ?? (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.first {
                    $0.title == "未分類"
                }?.id
            }
        }
    }
}
