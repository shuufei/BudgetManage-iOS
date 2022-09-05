//
//  CategoryListModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import SwiftUI

struct CategoryListModalView: View {
    @Binding var showModalView: Bool

    var body: some View {
        NavigationView {
            List {
                
            }
            .navigationTitle("カテゴリ一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {}
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {} label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct CategoryListModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListModalView(showModalView: .constant(true))
    }
}
