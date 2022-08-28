//
//  CategoryDetailModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/28.
//

import SwiftUI

struct CategoryDetailModalView: View {
    @Binding var budget: Budget
    @Binding var selectedCategoryId: UUID?
    @Binding var showModalView: Bool
    
    @State private var selectedView: CategoryDetailView = .addExpense
    
    private var category: BudgetCategory {
//        TODO: category指定された場合の処理を追加
        .uncategorized(UnCategorized(title: "未分類", budgetAmount: self.budget.uncategorizedBudgetAmount), self.budget.uncategorizedExpenses)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(self.category.displayData().title)
                        .font(.headline)
                    Spacer()
                    HStack {
                        Text("残り")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("¥\(self.category.displayData().balanceAmount)")
                            .font(.headline)
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 32)

                switch self.selectedView {
                case .addExpense:
                    AddExpenseView(budget: self.$budget) {
                        self.showModalView = false
                    }
                case .detail:
                    Text("詳細")
                }
            }
            .background(Color(UIColor.systemGray6))
            .navigationTitle(self.budget.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.showModalView = false
                    }
                }
                ToolbarItem(placement: .principal) {
                    Picker("", selection: self.$selectedView) {
                        Text("出費").tag(CategoryDetailView.addExpense)
                        Text("詳細").tag(CategoryDetailView.detail)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
            }
        }
    }
}

struct CategoryDetailModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailModalView(
            budget: .constant(Budget.sampleData[0]),
            selectedCategoryId: .constant(Budget.sampleData[0].categories[0].id),
            showModalView: .constant(true)
        )
    }
}

enum CategoryDetailView {
    case addExpense, detail
}
