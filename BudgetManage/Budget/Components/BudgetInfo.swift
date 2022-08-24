//
//  BudgetInfo.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct BudgetInfo: View {
    let budget: Budget
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                    .frame(width: 16)
                Text("予算情報")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .trailing, spacing: 3) {
                    Text("タイトル")
                    Text("期間")
                    Text("予算額")
//                    TODO: 残額を表示
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(self.budget.title)
                    Text(Budget.Data.computedTitle(startDate: self.budget.startDate, endDate: self.budget.endDate))
                    Text("¥\(self.budget.budgetAmount)")
                }
                .foregroundColor(.secondary)
            }
            .font(.caption)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(12)
        }
        .padding()
    }
}

struct BudgetInfo_Previews: PreviewProvider {
    static var previews: some View {
        BudgetInfo(budget: Budget.sampleData[0])
    }
}
