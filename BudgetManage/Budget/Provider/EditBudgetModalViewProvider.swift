//
//  EditBudgetModalViewProvider.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/17.
//

import SwiftUI

struct EditBudgetModalViewProvider: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>
    
    let editTarget: BudgetCD?
    
    var body: some View {
        EditBudgetModalView(currentBudget: self.editTarget) { budget in
              let budgetCategoriesAmount = (self.editTarget?.budgetCategories?.allObjects as? [BudgetCategoryCD])?.reduce(0, {x, y in
                  return x + (y.title != "未分類" ? y.budgetAmount : 0)
            }) ?? 0
            self.editTarget?.uncategorizedBudgetCategory?.budgetAmount = budget.budgetAmount - budgetCategoriesAmount
            self.uiStateEntities.first?.updatedAt = Date()
            try? self.viewContext.save()
        }
    }
}
