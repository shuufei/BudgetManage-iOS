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
    @State var openedEditBudgetModal: Bool = false
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
                        ScrollView {
                            VStack {
                                BudgetInfo(budget: self.budgetStore.selectedBudget!)
                                    .padding(.all, 12)
                                CategoryListView()
                                    .padding(.horizontal, 12)
                                Spacer()
                            }
                            .padding(.bottom, 96)
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
                            self.openedEditBudgetModal = true
                        } onTapCreateBudget: {
                            self.openedCreateBudgetModal = true
                        } onTapShowBudgetList: {
                            self.openedBudgetListModal = true
                        } onTapShowCategoryList: {
                            self.openedCategoryListModal = true
                        }
                    }
                }
                .sheet(isPresented: self.$openedEditBudgetModal) {
                    if let selectedBudget = self.budgetStore.selectedBudget {
                        EditBudgetModalView(budget: selectedBudget) { budget in
                            self.budgetStore.selectedBudget = budget
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
                    CategoryTemplateListModalView(
                        showModalView: self.$openedCategoryListModal
                    )
                }
                .ignoresSafeArea(edges: [.bottom])
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
