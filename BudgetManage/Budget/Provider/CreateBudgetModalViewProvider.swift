//
//  CreateBudgetModalProvider.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CreateBudgetModalViewProvider: View {
    @Binding var openedCreateBudgetModal: Bool
    @Binding var budgets: [Budget]
    
    var body: some View {
        CreateBudgetModalView(isCreateMode: $openedCreateBudgetModal) { newBudget in
            let budget = Budget(data: newBudget)
            var tmpBudgets = self.budgets
            tmpBudgets.append(budget)
            for (index, element) in tmpBudgets.enumerated() {
                tmpBudgets[index].isActive = element.id == budget.id ? true : false
            }
            self.budgets = tmpBudgets
        }
    }
}

struct CreateBudgetModalProvider_Previews: PreviewProvider {
    static var previews: some View {
        CreateBudgetModalViewProvider(openedCreateBudgetModal: .constant(true), budgets: .constant(Budget.sampleData))
    }
}
