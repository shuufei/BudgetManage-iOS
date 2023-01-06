//
//  CategoryListView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct CategoryListView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    @State private var showCategoryDetailModalView: Bool = false
    @State private var selectedBudgetCategoryId: UUID? = nil
    
    @State private var showAddBudgetCategoryModalView: Bool = false
    
    @State private var dragging: Category?
    
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
                if let budget = self.budgetStore.selectedBudget {
                    ForEach(budget.categories) { category in
                        Button(role: .none) {
                            self.selectedBudgetCategoryId = category.id
                            self.showCategoryDetailModalView = true
                        } label: {
                            CategoryCard(
                                budgetCategory: self.getBudgetCategory(category: category)
                            )
                        }
                        .opacity(self.dragging?.id == category.id ? 0.4 : 1)
                        .buttonStyle(.plain)
                        .onDrag {
                            self.dragging = category
                            return NSItemProvider(object: budget.id.uuidString as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: BudgetCategoryDragDelegate(
                            item: category,
                            budgetStore: self.budgetStore,
                            current: $dragging
                        ))
                    }
                    .onMove(perform: {_, _ in})

                    Button(role: .none) {
                        self.selectedBudgetCategoryId = nil
                        self.showCategoryDetailModalView = true
                    } label: {
                        CategoryCard(
                            budgetCategory: .uncategorized(
                                UnCategorized(
                                    title: "未分類",
                                    budgetAmount: budget.uncategorizedBudgetAmount
                                ),
                                budget.uncategorizedExpenses
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
                
            }
        }
        .sheet(isPresented: self.$showCategoryDetailModalView) {
            CategoryDetailModalView(
                selectedCategoryId: self.$selectedBudgetCategoryId,
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
    let item: Category
    var budgetStore: BudgetStore
    @Binding var current: Category?
    
    func dropEntered(info: DropInfo) {
        if item != current, self.budgetStore.selectedBudget != nil {
            let from = self.budgetStore.selectedBudget!.categories.firstIndex(of: current!)!
            let to = self.budgetStore.selectedBudget!.categories.firstIndex(of: item)!
            if self.budgetStore.selectedBudget!.categories[to].id != current!.id {
                self.budgetStore.selectedBudget!.categories.move(fromOffsets: IndexSet(integer: from),
                              toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}

