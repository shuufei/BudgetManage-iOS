//
//  AddExpenseModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import SwiftUI

struct AddExpenseModalView: View {
    @Binding var showModalView: Bool
    
    var body: some View {
        NavigationView {
            AddExpenseView() {
                self.showModalView = false
            }
            .navigationTitle("出費 追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.showModalView = false
                    }
                }
            }
        }
    }
}

struct AddExpenseModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseModalView(showModalView: .constant(false))
    }
}
