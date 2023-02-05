//
//  BudgetView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: BudgetCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) var budgets: FetchedResults<BudgetCD>
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>

    @State var openedEditBudgetModal: Bool = false
    @State var openedCreateBudgetModal: Bool = false
    @State var openedBudgetListModal: Bool = false
    @State var openedCategoryListModal: Bool = false
    @State private var showDeleteConfirmAlert: Bool = false

    var navigationTitle: String {
        return self.activeBudget?.title ?? "予算"
    }
    
    var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }

    var body: some View {
        NavigationView {
            ZStack {
                if self.activeBudget != nil {
                    Color(UIColor.systemGray5)
                    ScrollView {
                        VStack {
                            BudgetInfo()
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
                    } onTapDeleteBudget: {
                        self.showDeleteConfirmAlert = true
                    } onTapShowBudgetList: {
                        self.openedBudgetListModal = true
                    } onTapShowCategoryList: {
                        self.openedCategoryListModal = true
                    }
                }
            }
            .sheet(isPresented: self.$openedEditBudgetModal) {
                if let budget = self.activeBudget {
                    EditBudgetModalViewProvider(editTarget: budget)
                }
            }
            .sheet(isPresented: self.$openedCreateBudgetModal) {
                CreateBudgetModalViewProvider(
                    openedCreateBudgetModal: self.$openedCreateBudgetModal
                )
            }
            .sheet(isPresented: self.$openedBudgetListModal) {
                BudgetListModalView()
            }
            .sheet(isPresented: self.$openedCategoryListModal) {
                CategoryTemplateListModalView(
                    showModalView: self.$openedCategoryListModal
                )
            }
            .alert("予算の削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.activeBudget) { budget in
                    Button("削除", role: .destructive) {
                        viewContext.delete(budget)
                        self.uiStateEntities.first?.updatedAt = Date()
                        self.uiStateEntities.first?.activeBudget = self.budgets.first { $0.id != budget.id }
                        try? viewContext.save()
                    }
            } message: { budget in
                Text("予算を削除すると、予算に紐づく出費記録も削除されます。")
            }
            .ignoresSafeArea(edges: [.bottom])
        }
    }
}

