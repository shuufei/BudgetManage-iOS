//
//  CreateBudgetModalProvider.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CreateBudgetModalViewProvider: View {
    @EnvironmentObject private var budgetStore: BudgetStore

    @Binding var openedCreateBudgetModal: Bool
    
    var body: some View {
        CreateBudgetModalView(isCreateMode: self.$openedCreateBudgetModal) { newBudget in
            let budget = Budget(data: newBudget)
            var tmpBudgets = self.budgetStore.budgets
            tmpBudgets.append(budget)
            for (index, element) in tmpBudgets.enumerated() {
                tmpBudgets[index].isActive = element.id == budget.id ? true : false
            }
            self.budgetStore.budgets = tmpBudgets
        }
    }
}

struct CreateBudgetModalProvider_Previews: PreviewProvider {
    static var previews: some View {
        CreateBudgetModalViewProvider(openedCreateBudgetModal: .constant(true))
            .environmentObject(BudgetStore())
    }
}
