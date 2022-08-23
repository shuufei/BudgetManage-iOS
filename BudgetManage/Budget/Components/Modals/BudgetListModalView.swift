//
//  BudgetListModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/23.
//

import SwiftUI

struct BudgetListModalView: View {
    @Binding var showBudgetList: Bool
    @Binding var budgets: [Budget]
    @State var openedCreateBudgetModal: Bool = false

    func getFormattedBudgetAmout(budgetAmount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(
            from: NSNumber(value: budgetAmount)
        ) ?? "0"
        return "¥\(formatted)"
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(budgets) { budget in
                    Button(role: .none) {
                        for (index, element) in self.budgets.enumerated() {
                            self.budgets[index].isActive = element.id == budget.id ? true : false
                        }
                        self.showBudgetList = false
                    } label: {
                        HStack {
                            if budget.isActive ?? false {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundColor(.green)
                                    .frame(width: 20, height: 20)
                            } else {
                                Text("")
                                    .frame(width: 20)
                            }
                            Text(budget.title)
                            Spacer()
                            Text(self.getFormattedBudgetAmout(budgetAmount: budget.budgetAmount))
                                .foregroundColor(.secondary)
                            
                        }
                    }
                    .foregroundColor(.black)
                    .swipeActions {
                        Button {} label: {
                            Text("削除")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle("予算一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        self.showBudgetList = false
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
                CreateBudgetModalViewProvider(openedCreateBudgetModal: self.$openedCreateBudgetModal, budgets: self.$budgets)
            }
        }
    }
}

struct BudgetListModalView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListModalView(showBudgetList: .constant(true), budgets: .constant(Budget.sampleData))
    }
}
