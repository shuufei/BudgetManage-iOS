//
//  BudgetCategoryPicker.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2022/10/26.
//

import SwiftUI

struct BudgetCategoryPicker: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>

    @Binding var selectedBudgetCategoryId: UUID?
    
//    private let UNCATEGORIZED_UUID_FOR_PICKER = UUID()
    
    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    private var budgetCategories: [BudgetCategoryCD] {
        (self.activeBudget?.budgetCategories?.allObjects as? [BudgetCategoryCD]) ?? []
//        if let categories = self.budgetStore.selectedBudget?.categories {
//            return getBudgetCategorieDisplayDataList(categories: categories, categoryTemplates: self.categoryTemplateStore.categories)
//        }
//        return []
    }

    var body: some View {
        if self.budgetCategories.count >= 1 {
            //        REF: https://stackoverflow.com/questions/65924526/deselecting-item-from-a-picker-swiftui
            Picker("カテゴリ", selection: Binding(self.$selectedBudgetCategoryId, deselectTo: UUID())) {
//                Text("リセット").tag(self.UNCATEGORIZED_UUID_FOR_PICKER)

                ForEach(self.budgetCategories, id: \.id) { budgetCategory in
                    CategoryTemplateLabel(
                        title: budgetCategory.title,
                        mainColor: budgetCategory.mainColor,
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
