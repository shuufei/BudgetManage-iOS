//
//  BudgetInfo.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct BudgetInfo: View {
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>
    
    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    private var totalExpenseAmount: Int32 {
        return (self.activeBudget?.expenses?.allObjects as? [ExpenseCD])?.reduce(0, {x, y in
            x + y.amount
        }) ?? 0
    }
    
    private var balanceAmount: Int32 {
        (self.activeBudget?.budgetAmount ?? 0) - self.totalExpenseAmount
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .trailing, spacing: 3) {
                    Text("予算名")
                    Text("期間")
                    Text("予算額")
                    Text("利用額")
                    Text("残額")
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(self.activeBudget?.title ?? "")
                    if let startDate = self.activeBudget?.startDate, let endDate = self.activeBudget?.endDate {
                        Text(Budget.Data.computedTitle(startDate: startDate, endDate: endDate))
                    }
                    Text("¥\(self.activeBudget?.budgetAmount ?? 0)")
                    Text("¥\(self.totalExpenseAmount)")
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

