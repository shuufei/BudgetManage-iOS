//
//  BudgetListModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/23.
//

import SwiftUI

struct BudgetListModalView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var budgetStore: BudgetStore
    @FetchRequest(entity: BudgetCD.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) var budgets: FetchedResults<BudgetCD>
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var uiStateEntities: FetchedResults<UICD>

    @State private var openedCreateBudgetModal: Bool = false
    @State private var showDeleteConfirmAlert: Bool = false
    @State private var deletionTarget: Budget? = nil
    
    @State private var editTarget: Budget? = nil

    func getFormattedBudgetAmout(budgetAmount: Int32) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(
            from: NSNumber(value: budgetAmount)
        ) ?? "0"
        return "¥\(formatted)"
    }
    
    private var activeBudget: BudgetCD? {
        self.uiStateEntities.first?.activeBudget
    }
    
    var body: some View {
        NavigationView {
            List {
                if self.budgets.count == 0 {
                    Text("予算が登録されていません")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.black.opacity(0))
                }
//                ForEach(self.budgetStore.budgets) { budget in
                ForEach(self.budgets) { budget in
                    Button(role: .none) {
                        if let ui = self.uiStateEntities.first {
                            ui.activeBudget = budget
                            ui.updatedAt = Date()
                            try? self.viewContext.save()
                        }
                        self.dismiss()
                    } label: {
                        HStack {
                            if self.activeBudget?.id == budget.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundColor(.green)
                                    .frame(width: 20, height: 20)
                            } else {
                                Text("")
                                    .frame(width: 20)
                            }
                            Text(budget.title ?? "")
                                .lineLimit(1)
                            Spacer()
                            Text(self.getFormattedBudgetAmout(budgetAmount: budget.budgetAmount))
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
                    .swipeActions {
                        Button {
                            self.showDeleteConfirmAlert = true
//                            self.deletionTarget = budget
                        } label: {
                            Text("削除")
                        }
                        .tint(.red)
                        Button(role: .none) {
//                            self.editTarget = budget
                        } label: {
                            Text("編集")
                        }
                        .tint(.gray)
                    }
                }
            }
            .navigationTitle("予算一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        self.openedCreateBudgetModal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: self.$openedCreateBudgetModal) {
                CreateBudgetModalViewProvider(
                    openedCreateBudgetModal: self.$openedCreateBudgetModal
                )
            }
            .alert("予算の削除", isPresented: self.$showDeleteConfirmAlert, presenting: self.deletionTarget) { budget in
                    Button("削除", role: .destructive) {
                        var tmpBudgets = self.budgetStore.budgets.filter { $0.id != budget.id }
                        let index = tmpBudgets.firstIndex {$0.isActive == true}
                        if index == nil && tmpBudgets.count != 0 {
                            tmpBudgets[0].isActive = true
                        }
                        self.budgetStore.budgets = tmpBudgets
                    }
            } message: { budget in
                Text("予算を削除すると、予算に紐づく出費記録も削除されます。")
            }
            .sheet(item: self.$editTarget) { editTarget in
                EditBudgetModalView(budget: editTarget) { budget in
                    if let index = self.budgetStore.budgets.firstIndex(where: {el in el.id == editTarget.id}) {
                        self.budgetStore.budgets[index] = budget
                    }
                }
            }
            .onAppear {
                if self.uiStateEntities.first == nil, let budget = self.budgets.first {
                    let newUI = UICD(context: self.viewContext)
                    newUI.updatedAt = Date()
                    newUI.activeBudget = budget
                    try? viewContext.save()
                }
            }
        }
    }
}
