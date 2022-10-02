//
//  CategoryAddExpenseView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/03.
//

import SwiftUI

struct CategoryAddExpenseView: View {
    var categoryId: UUID?
    var onAdded: () -> Void

    var body: some View {
        AddExpenseView(categoryId: self.categoryId) {
            self.onAdded()
        }
//        .onAppear {
//            if #available(iOS 15, *) {
//                UITableView.appearance().contentInset.top = -25
//            }
//        }
//        .onDisappear {
//            if #available(iOS 15, *) {
//                UITableView.appearance().contentInset.top = 0
//            }
//        }
    }
}

//struct CategoryAddExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryAddExpenseView()
//    }
//}
