//
//  CategoryDetailView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/29.
//

import SwiftUI

struct CategoryDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>

//    @Binding var selectedCategoryId: UUID?
    
    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: ExpenseCD? = nil

    @State private var editTarget: ExpenseCD? = nil
    
//    let budgetCategory: BudgetCategory
    let budgetCategory: BudgetCategoryCD
    
    private var expenses: [ExpenseCD] {
        self.budgetCategory.expenses?.allObjects as? [ExpenseCD] ?? []
//        self.budgetStore.selectedBudget?.expenses.filter {
//            $0.categoryId == self.selectedCategoryId
//        } ?? []
    }
    
    private func getFormattedDate(date: Date, includeTime: Bool = true) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y年M月d日\(includeTime ? " HH:mm" : "")"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

    var body: some View {
        List {
            Section {
                CategoryBudgetBar(budgetAmount: self.budgetCategory.budgetAmount, budgetBalanceAmount: self.budgetCategory.balanceAmount, mainColor: self.budgetCategory.mainColor)
                .listRowInsets(EdgeInsets(top: 12, leading: 12, bottom: 8, trailing: 12))
            }
            Section(header: Text("カテゴリ情報")) {
                HStack {
                    Text("予算額")
                    Spacer()
                    Text("¥\(self.budgetCategory.budgetAmount)")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("出費合計")
                    Spacer()
                    Text("¥\(self.budgetCategory.totalExpensesAmount)")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("残額")
                    Spacer()
                    Text("¥\(self.budgetCategory.balanceAmount)")
                        .foregroundColor(.secondary)
                }
            }
            Section(header: Text("出費")) {
                if self.expenses.count == 0 {
                    Text("出費がまだありません")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowBackground(Color.black.opacity(0))
                        .foregroundColor(.secondary)
                }
                ForEach(self.expenses) { expense in
                    HStack {
                        Text(self.getFormattedDate(date: expense.date!, includeTime: expense.includeTimeInDate))
                            .fixedSize(horizontal: true, vertical: true)
                        Spacer()
                        if !(expense.memo ?? "").isEmpty {
                            VStack(alignment: .trailing) {
                                Text("¥\(expense.amount)")
                                    .font(.callout)
                                Text(expense.memo ?? "")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        } else {
                            Text("¥\(expense.amount)")
                                .font(.callout)
                        }
                    }
                    .lineLimit(1)
                    .swipeActions {
                        Button(role: .destructive) {
                            self.showDeleteConfirmAlert = true
                            self.deletionTarget = expense
                        } label: {
                            Text("削除")
                        }
                        Button(role: .none) {
                            self.editTarget = expense
                        } label: {
                            Text("編集")
                        }
                        .tint(.gray)
                    }
                    .alert("出費の削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.deletionTarget) { expense in
                            Button("削除", role: .destructive) {
//                                TODO: 削除実行時にalertが重複して表示される問題を対応する
                                self.deletionTarget  = nil
                                self.showDeleteConfirmAlert = false
                                self.viewContext.delete(expense)
                                self.uiStateEntities.first?.updatedAt = Date()
                                try? self.viewContext.save()
//                                if var budget = self.budgetStore.selectedBudget {
//                                    budget.expenses = budget.expenses.filter { $0.id != expense.id }
//                                    // NOTE: https://developer.apple.com/forums/thread/676885
//                                    DispatchQueue.main.async {
//                                        self.budgetStore.selectedBudget = budget
//                                    }
//                                }
                            }
                    } message: { expense in
                        Text("出費の記録を削除しますか?")
                    }
                }
            }
        }
        .sheet(item: self.$editTarget) { editTarget in
//            EditExpenseModalView(expense: editTarget) { expense in
//            }
            EditBudgetModalView(budget: Budget(startDate: Date(), endDate: Date(), budgetAmount: 0), onSave: {data in})
//            if var budget = self.budgetStore.selectedBudget, let expenseIndex = budget.expenses.firstIndex(where: { el in
//                el.id == editTarget.id
//            }), let expense = budget.expenses[expenseIndex] {
//                EditExpenseModalView(expense: editTarget) { expense in
//    //                budget.expenses[expenseIndex] = expense
//    //                self.budgetStore.selectedBudget = budget
//                }
//            }
        }
        .onAppear {
            if #available(iOS 15, *) {
                UITableView.appearance().contentInset.top = -25
            }
        }
        .onDisappear {
            if #available(iOS 15, *) {
                UITableView.appearance().contentInset.top = .zero
            }
        }
    }
}
