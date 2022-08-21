//
//  BudgetView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetView: View {
    let budgets: [Budget]
    var activeBudget: Budget? {
        self.budgets.first { $0.isActive == true }
    }
    var navigationTitle: String {
        return self.activeBudget?.title ?? "予算"
    }

    var body: some View {
        NavigationView {
            VStack {
                if let budget = activeBudget {
                    Text("title: \(budget.title)")
                    Text("startDate: \(budget.startDate.ISO8601Format())")
                    Text("endDate: \(budget.endDate.ISO8601Format())")
                    Text("budgetAmount: ¥\(budget.budgetAmount)")
                }
            }
            .navigationTitle(self.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BudgetViewNavigationTitle(title: navigationTitle)
                }
                ToolbarItem(placement: .primaryAction) {
                    BudgetViewMenu()
                }
            }
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView(budgets: Budget.sampleData)
    }
}
