//
//  CategoryInfo.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/03.
//

import SwiftUI

struct CategoryInfo: View {
    @Environment(\.colorScheme) var colorScheme
    var category: BudgetCategory
    
    var data: BudgetCategory.CategoryDisplayData {
        self.category.displayData()
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .trailing, spacing: 3) {
                    Text("カテゴリ予算額")
                    Text("出費")
                    Text("残額")
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("¥\(self.data.budgetAmount)")
                    Text("¥\(self.data.totalExpenseAmount)")
                    Text("¥\(self.data.balanceAmount)")
                }
                .foregroundColor(.secondary)
            }
            .font(.caption)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(self.colorScheme == .dark ? .black : .white)
            .cornerRadius(8)
        }
    }
}

struct CategoryInfo_Previews: PreviewProvider {
    static var previews: some View {
        CategoryInfo(category: .uncategorized(UnCategorized(title: "未分類", budgetAmount: 1000), []))
    }
}
