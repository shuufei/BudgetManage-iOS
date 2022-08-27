//
//  AddExpenseButton.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import SwiftUI

struct AddExpenseButton: View {
    @Binding var currentBudget: Budget
    @State var showAddExpenseModal: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        self.showAddExpenseModal = true
                    } label: {
                        Label("出費", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
            .sheet(isPresented: self.$showAddExpenseModal) {
                AddExpenseModalView(showModalView: self.$showAddExpenseModal, currentBudget: self.$currentBudget)
            }
        }
    }
}

struct AddExpenseButton_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseButton(currentBudget: .constant(Budget.sampleData[0]))
    }
}
