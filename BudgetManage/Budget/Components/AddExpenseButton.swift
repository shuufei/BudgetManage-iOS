//
//  AddExpenseButton.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import SwiftUI

struct AddExpenseButton: View {
    var body: some View {
        Button {} label: {
            Label("出費", systemImage: "plus")
        }
        .buttonStyle(.borderedProminent)
    }
}

struct AddExpenseButton_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseButton()
    }
}
