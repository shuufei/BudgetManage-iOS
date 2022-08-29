//
//  CategoryTitle.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/29.
//

import SwiftUI

struct CategoryTitle: View {
    var category: BudgetCategory
    var body: some View {
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
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.white.opacity(0))
        .padding(.horizontal, 12)
    }
}

struct CategoryTitle_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTitle(category: .uncategorized(UnCategorized(title: "未分類", budgetAmount: 1000), []))
    }
}
