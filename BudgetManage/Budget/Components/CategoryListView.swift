//
//  CategoryListView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct CategoryListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @FetchRequest(entity: BudgetCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) private var budgets: FetchedResults<BudgetCD>
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>

    @State private var showCategoryDetailModalView: Bool = false
    @State private var selectedBudgetCategoryId: UUID? = nil
    
    @State private var showAddBudgetCategoryModalView: Bool = false
    
    @State private var dragging: BudgetCategoryCD?
    
    private var activeBudget: BudgetCD? {
        return self.uiStateEntities.first?.activeBudget
    }
    
    private func getCategoryTemplate(categoryTemplateId: UUID) -> CategoryTemplate? {
        self.categoryTemplateStore.categories.first { $0.id == categoryTemplateId }
    }
    
    private func getCategoryExpenses(categoryId: UUID) -> [Expense] {
        self.budgetStore.selectedBudget?.expenses.filter { $0.categoryId == categoryId } ?? []
    }
    
    private func getBudgetCategory(category: Category) -> BudgetCategory {
        if let categoryTemplate = self.getCategoryTemplate(categoryTemplateId: category.categoryTemplateId) {
            return .categorized(category, categoryTemplate, self.getCategoryExpenses(categoryId: category.id))
        } else {
            return .uncategorized(UnCategorized(title: "", budgetAmount: 0), [])
        }
    }
    
    private func budgetCategoriesArray(_ budgetCategories: NSSet?) -> [BudgetCategoryCD] {
        budgetCategories?.allObjects as? [BudgetCategoryCD] ?? []
    }
    
    private func getTotalExpenseAmount(_ expenses: [ExpenseCD]) -> Int32 {
        expenses.reduce(0, { x, y in
            x + y.amount
        })
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("カテゴリ")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button {
                    self.showAddBudgetCategoryModalView = true
                } label: {
                    Text("編集")
                        .font(.callout)
                }
            }
            .padding(.horizontal, 8)
            VStack(spacing: 12) {
                if let budget = self.activeBudget {
                    ForEach(budget.sortedBudgetCategories ?? []) { category in
                        Button(role: .none) {
                            self.selectedBudgetCategoryId = category.id
                            self.showCategoryDetailModalView = true
                        } label: {
                            CategoryCard(budgetCategoryTitle: category.title, budgetAmount: category.budgetAmount, budgetBalanceAmount: category.balanceAmount, budgetCategoryMainColor: category.mainColor)
                        }
                        .opacity(self.dragging?.id == category.id ? 0.4 : 1)
                        .buttonStyle(.plain)
                        .onDrag {
                            self.dragging = category
                            return NSItemProvider(object: budget.id!.uuidString as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: BudgetCategoryDragDelegate(
                            activeBudget: self.activeBudget, droppedItem: category, draggingItem: self.$dragging, onCommit: { budgetCategories in
                                self.activeBudget?.budgetCategories = NSSet(array:budgetCategories)
                                self.uiStateEntities.first?.updatedAt = Date()
                                try? self.viewContext.save()
                            }
                        ))
                    }
                    .onMove(perform: {_, _ in})
                    
                    /*
                     
                     NOTE:
                     budget切り替え時に未分類のカードを強制再renderさせるためのForEach
                     再renderにより、barのanimationが実行される
                     */
//                    ForEach([budget]) {_ in
//                        Button(role: .none) {
//                            self.selectedBudgetCategoryId = nil
//                            self.showCategoryDetailModalView = true
//                        } label: {
//                            CategoryCard(budgetCategoryTitle: "未分類", budgetAmount: budget.uncategorizedBudgetAmount, budgetBalanceAmount: self.getTotalExpenseAmount(budget.uncategorizedExpenses), budgetCategoryMainColor: Color(UIColor.systemGray))
//                        }
//                        .buttonStyle(.plain)
//                    }
                }
                
            }
        }
        .sheet(isPresented: self.$showCategoryDetailModalView) {
            CategoryDetailModalView(
                selectedBudgetCategoryId: self.$selectedBudgetCategoryId,
                showModalView: self.$showCategoryDetailModalView
            )
        }
        .sheet(isPresented: self.$showAddBudgetCategoryModalView) {
            EditBudgetCategoryModalView()
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(UIColor.systemGray5)
            CategoryListView()
                .environmentObject(BudgetStore())
                .environmentObject(CategoryTemplateStore())
        }
    }
}

struct BudgetCategoryDragDelegate: DropDelegate {
    @Environment(\.managedObjectContext) private var viewContext
    let activeBudget: BudgetCD?
    let droppedItem: BudgetCategoryCD
    @Binding var draggingItem: BudgetCategoryCD?
    let onCommit: (_ budgetCategories: [BudgetCategoryCD]) -> Void
    
    func dropEntered(info: DropInfo) {
        if let dragging = self.draggingItem, self.droppedItem != dragging, self.activeBudget != nil, var budgetCategories = self.activeBudget!.sortedBudgetCategories {
            let from = budgetCategories.firstIndex(of: dragging)!
            let to = budgetCategories.firstIndex(of: self.droppedItem)!
            if budgetCategories[to].id != dragging.id {
//              最新のsortされた状態でmoveすることで、適切な並び順の配列にする。
//              その後、適切な並び順でsortIndexを割り当てる。
//              budgetに対してbudgetCategoryは別モデルのため、配列を直接上書きしても、配列の並び順は保持されないのでsortIndexを用いる必要がある
                budgetCategories.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
                budgetCategories.enumerated().forEach({ index, bc in
                    bc.sortIndex = Int16(index)
                })
                self.onCommit(budgetCategories)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.draggingItem = nil
        return true
    }
}

