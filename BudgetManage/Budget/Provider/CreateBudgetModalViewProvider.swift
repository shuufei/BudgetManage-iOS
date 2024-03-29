//
//  CreateBudgetModalProvider.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI

struct CreateBudgetModalViewProvider: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>

    @Binding var openedCreateBudgetModal: Bool
    
    var body: some View {
        CreateBudgetModalView(isCreateMode: self.$openedCreateBudgetModal) { newBudget in
            let budget = BudgetCD(context: self.viewContext)
            budget.id = UUID()
            budget.title = newBudget.title
            budget.startDate = newBudget.startDate
            budget.endDate = newBudget.endDate
            budget.budgetAmount = Int32(newBudget.budgetAmount)
            budget.createdAt = Date()
            
            let uncategorizedBudgetCategory = BudgetCategoryCD(context: self.viewContext)
            uncategorizedBudgetCategory.id = UUID()
            uncategorizedBudgetCategory.budgetAmount = budget.budgetAmount
            uncategorizedBudgetCategory.createdAt = Date()
            
            budget.addToBudgetCategories(uncategorizedBudgetCategory)
            
            let ui = self.uiStateEntities.first ?? UICD(context: self.viewContext)
            ui.updatedAt = Date()
            ui.activeBudget = budget
            
            try? viewContext.save()
        }
    }
}
