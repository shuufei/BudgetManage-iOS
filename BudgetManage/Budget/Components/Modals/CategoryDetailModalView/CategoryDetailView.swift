//
//  CategoryDetailView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/29.
//

import SwiftUI

struct CategoryDetailView: View {
    let budgetCategory: BudgetCategoryCD

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme

    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>
    
    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: ExpenseCD? = nil
    @State private var editTarget: ExpenseCD? = nil
    
    private var expenses: [ExpenseCD] {
        self.budgetCategory.expenses?.allObjects as? [ExpenseCD] ?? []
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
                CategoryBudgetBar(budgetAmount: self.budgetCategory.budgetAmount, budgetBalanceAmount: self.budgetCategory.balanceAmount, mainColor: self.budgetCategory.mainColor ?? self.budgetCategory.getUncategorizedMainColor(self.colorScheme))
                .listRowInsets(EdgeInsets(top: 12, leading: 12, bottom: 8, trailing: 12))
            }.padding(.top, 4)
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
                ForEach(self.expenses.sorted(by: { $0.date ?? Date() > $1.date ?? Date()})) { expense in
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
                }
            }
        }
        .alert("出費の削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.deletionTarget) { expense in
            Button("削除", role: .destructive) {
                self.viewContext.delete(expense)
                self.uiStateEntities.first?.updatedAt = Date()
                try? self.viewContext.save()
                self.deletionTarget  = nil
            }
        } message: { expense in
            Text("出費の記録を削除しますか?")
        }
        .sheet(item: self.$editTarget) { editTarget in
            EditExpenseModalView(expense: editTarget)
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
