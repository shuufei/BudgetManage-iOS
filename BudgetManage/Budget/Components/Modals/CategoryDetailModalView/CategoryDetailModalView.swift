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
    
    @State private var selectedView: CategoryDetailViewType = .addExpense
    
    private var category: BudgetCategory {
//        TODO: category指定された場合の処理を追加
        .uncategorized(UnCategorized(title: "未分類", budgetAmount: self.budget.uncategorizedBudgetAmount), self.budget.uncategorizedExpenses)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CategoryTitle(category: self.category)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                switch self.selectedView {
                case .addExpense:
                    AddExpenseView(budget: self.$budget) {
                        self.showModalView = false
                    }
                case .detail:
                    CategoryDetailView(budget: self.$budget, selectedCategoryId: self.$selectedCategoryId)
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
                        Text("出費").tag(CategoryDetailViewType.addExpense)
                        Text("詳細").tag(CategoryDetailViewType.detail)
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

enum CategoryDetailViewType {
    case addExpense, detail
}
