//
//  BudgetInfo.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct BudgetInfo: View {
    @Environment(\.colorScheme) var colorScheme
    let budget: Budget
    
    var totalExpenseAmount: Int {
        self.budget.expenses.reduce(0, {x, y in
            x + y.amount
        })
    }
    
    var balanceAmount: Int {
        self.budget.budgetAmount - self.totalExpenseAmount
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .trailing, spacing: 3) {
                    Text("タイトル")
                    Text("期間")
                    Text("予算額")
                    Text("残額")
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(self.budget.title)
                    Text(Budget.Data.computedTitle(startDate: self.budget.startDate, endDate: self.budget.endDate))
                    Text("¥\(self.budget.budgetAmount)")
                    Text("¥\(self.balanceAmount)")
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

struct BudgetInfo_Previews: PreviewProvider {
    static var previews: some View {
        BudgetInfo(budget: Budget.sampleData[0])
    }
}
