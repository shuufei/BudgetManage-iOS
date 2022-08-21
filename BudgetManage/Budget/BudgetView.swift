//
//  BudgetView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetView: View {
    let budget: Budget
    var body: some View {
        VStack {
            Text("title: \(budget.title)")
            Text("startDate: \(budget.startDate.ISO8601Format())")
            Text("endDate: \(budget.endDate.ISO8601Format())")
            Text("budgetAmount: ¥\(budget.budgetAmount)")
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView(budget: Budget.sampleData[1])
    }
}
