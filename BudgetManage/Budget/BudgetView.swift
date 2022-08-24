//
//  BudgetView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetView: View {
    @Binding var budgets: [Budget]
    @State var openedCreateBudgetModal: Bool = false
    @State var openedBudgetListModal: Bool = false

    var activeBudget: Budget? {
        let budget = self.budgets.first { $0.isActive == true }
        if budget == nil && self.budgets.count > 0 {
            return self.budgets[0]
        }
        return budget
    }
    var navigationTitle: String {
        return self.activeBudget?.title ?? "予算"
    }

    var body: some View {
        NavigationView {
                ZStack {
                    if let budget = activeBudget {
                        Color(UIColor.systemGray5)
                        VStack {
                            BudgetInfo(budget: budget)
                            Spacer()
                        }
//                        List {
//                            Section(header: Text("予算情報")) {
//                            }
//                            .headerProminence(.standard)
//                        }
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
                        }
                    }
                }
                .sheet(isPresented: $openedCreateBudgetModal) {
                    CreateBudgetModalViewProvider(openedCreateBudgetModal: self.$openedCreateBudgetModal, budgets: self.$budgets)
                }
                .sheet(isPresented: $openedBudgetListModal) {
                    BudgetListModalView(
                        showBudgetList: $openedBudgetListModal,
                        budgets: $budgets
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
            BudgetView(budgets: .constant(Budget.sampleData))
        }
    }
}
