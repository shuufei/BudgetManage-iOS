//
//  BudgetView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @State var openedCreateBudgetModal: Bool = false
    @State var openedBudgetListModal: Bool = false
    @State var openedCategoryListModal: Bool = false

    var categoryTemplates: [CategoryTemplate] {
        self.categoryTemplateStore.categories
    }

    var navigationTitle: String {
        return self.budgetStore.selectedBudget?.title ?? "予算"
    }

    var body: some View {
        NavigationView {
                ZStack {
                    if self.budgetStore.selectedBudget != nil {
                        Color(UIColor.systemGray5)
                        VStack {
                            BudgetInfo(budget: self.budgetStore.selectedBudget!)
                                .padding(.all, 12)
                            CategoryListView()
                                .padding(.horizontal, 12)
                            Spacer()
                        }
                        AddExpenseButton()
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
                    CreateBudgetModalViewProvider(
                        openedCreateBudgetModal: self.$openedCreateBudgetModal
                    )
                }
                .sheet(isPresented: self.$openedBudgetListModal) {
                    BudgetListModalView(
                        showBudgetList: $openedBudgetListModal
                    )
                }
                .sheet(isPresented: self.$openedCategoryListModal) {
//                    CategoryTemplateListModalView(
//                        categoryTemplates: self.$categoryTemplates,
//                        budgetExpenses: self.budgets.count > 0 ? self.$budgets[self.activeBudgetIndex].expenses : .constant([]),
//                        showModalView: self.$openedCategoryListModal
//                    )
                }
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BudgetView()
                .environmentObject(BudgetStore())
                .environmentObject(CategoryTemplateStore())
        }
    }
}
