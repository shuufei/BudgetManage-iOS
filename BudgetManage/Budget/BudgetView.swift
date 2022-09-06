//
//  BudgetView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetView: View {
    @Binding var budgets: [Budget]
    @Binding var categoryTemplates: [CategoryTemplate]
    @State var openedCreateBudgetModal: Bool = false
    @State var openedBudgetListModal: Bool = false
    @State var openedCategoryListModal: Bool = false

    var activeBudgetIndex: Int {
        let index = self.budgets.firstIndex { $0.isActive == true }
        return index ?? 0
    }
    var navigationTitle: String {
        return self.budgets.indices.contains(self.activeBudgetIndex) ? self.budgets[self.activeBudgetIndex].title : "予算"
    }

    var body: some View {
        NavigationView {
                ZStack {
                    if self.budgets.count > 0 {
                        Color(UIColor.systemGray5)
                        VStack {
                            BudgetInfo(budget: self.budgets[self.activeBudgetIndex])
                                .padding(.all, 12)
                            CategoryListView(budget: self.$budgets[self.activeBudgetIndex])
                                .padding(.horizontal, 12)
                            Spacer()
                        }
                        AddExpenseButton(currentBudget: self.$budgets[self.activeBudgetIndex])
                    } else {
                        BudgetEmptyView(openedCreateBudgetModal: $openedCreateBudgetModal)
                    }
                }
                .navigationTitle(self.navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        BudgetViewNavigationTitle(title: self.navigationTitle, openedBudgetListModal: $openedBudgetListModal)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        BudgetViewMenu() {
                            self.openedCreateBudgetModal = true
                        } onTapShowBudgetList: {
                            self.openedBudgetListModal = true
                        } onTapShowCategoryList: {
                            self.openedCategoryListModal = true
                        }
                    }
                }
                .sheet(isPresented: self.$openedCreateBudgetModal) {
                    CreateBudgetModalViewProvider(openedCreateBudgetModal: self.$openedCreateBudgetModal, budgets: self.$budgets)
                }
                .sheet(isPresented: self.$openedBudgetListModal) {
                    BudgetListModalView(
                        showBudgetList: $openedBudgetListModal,
                        budgets: $budgets
                    )
                }
                .sheet(isPresented: self.$openedCategoryListModal) {
                    CategoryTemplateListModalView(
                        categoryTemplates: self.$categoryTemplates,
                        budgetExpenses: self.budgets.count > 0 ? self.$budgets[self.activeBudgetIndex].expenses : .constant([]),
                        showModalView: self.$openedCategoryListModal
                    )
                }
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            BudgetView(budgets: .constant([]))
//            BudgetView(budgets: .constant([]))
            BudgetView(budgets: .constant(Budget.sampleData), categoryTemplates: .constant([]))
        }
    }
}
