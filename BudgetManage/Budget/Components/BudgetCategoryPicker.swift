//
//  BudgetCategoryPicker.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2022/10/26.
//

import SwiftUI

struct BudgetCategoryPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>

    @Binding var selectedBudgetCategoryId: UUID?
    
//    private let UNCATEGORIZED_UUID_FOR_PICKER = UUID()
    
    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    private var budgetCategories: [BudgetCategoryCD] {
        (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD]) ?? []
    }

    var body: some View {
        if self.budgetCategories.count >= 1 {
            //        REF: https://stackoverflow.com/questions/65924526/deselecting-item-from-a-picker-swiftui
            Picker("カテゴリ", selection: Binding(self.$selectedBudgetCategoryId, deselectTo: UUID())) {

                ForEach(self.budgetCategories, id: \.id) { budgetCategory in
                    CategoryTemplateLabel(
                        title: budgetCategory.title,
                        mainColor: budgetCategory.mainColor ?? budgetCategory.getUncategorizedMainColor(self.colorScheme),
                        accentColor: budgetCategory.accentColor
                    ).tag(budgetCategory.id)
                }
            }
        }
    }
}

fileprivate extension Binding where Value: Equatable {
    init(_ source: Binding<Value>, deselectTo value: Value) {
        self.init(get: { source.wrappedValue },
                  set: { source.wrappedValue = $0 == source.wrappedValue ? value : $0 }
        )
    }
}
