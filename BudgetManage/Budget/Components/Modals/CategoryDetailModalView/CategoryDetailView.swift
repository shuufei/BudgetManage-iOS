//
//  CategoryDetailView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/29.
//

import SwiftUI

struct CategoryDetailView: View {
    @Binding var budget: Budget
    @Binding var selectedCategoryId: UUID?
    
    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: Expense? = nil
    
    @State private var showEditModalView: Bool = false
    @State private var editTarget: Expense? = nil
    
    private var expenses: [Expense] {
        self.budget.expenses.filter {
            $0.categoryId == self.selectedCategoryId
        }
    }
    
    private func getFormattedDate(date: Date, includeTime: Bool = true) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y年M月d日\(includeTime ? " h:m" : "")"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

    var body: some View {
        List {
            Section(header: Text("出費")) {
                ForEach(self.expenses) { expense in
                    HStack {
                        Text(self.getFormattedDate(date: expense.date, includeTime: expense.includeTimeInDate))
                            .fixedSize(horizontal: true, vertical: true)
                        Spacer()
                        if !(expense.memo).isEmpty {
                            VStack(alignment: .trailing) {
                                Text("¥\(expense.amount)")
                                    .font(.callout)
                                Text(expense.memo)
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
                            self.showEditModalView = true
                            self.editTarget = expense
                        } label: {
                            Text("編集")
                        }
                        .tint(.gray)
                    }
                    .alert("出費の削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.deletionTarget) { expense in
                            Button("削除", role: .destructive) {
                                let expenses = self.budget.expenses.filter { $0.id != expense.id }
                                self.budget.expenses = expenses
                            }
                    } message: { expense in
                        Text("出費の記録を削除しますか?")
                    }
                }
            }
        }
        .sheet(isPresented: self.$showEditModalView) {
            let index = self.budget.expenses.firstIndex { el in
                el.id == self.editTarget?.id
            }
            EditExpenseModalView(expense: self.$budget.expenses[index!], showModalView: self.$showEditModalView)
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(
            budget: .constant(Budget.sampleData[0]),
            selectedCategoryId: .constant(nil)
        )
    }
}
