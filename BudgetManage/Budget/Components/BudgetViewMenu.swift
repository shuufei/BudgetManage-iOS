//
//  BudgetViewMenu.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetViewMenu: View {
    let onTapEditBudget: () -> Void
    let onTapCreateBudget: () -> Void
    let onTapDeleteBudget: () -> Void
    let onTapShowBudgetList: () -> Void
    let onTapShowCategoryList: () -> Void
    
    var body: some View {
        Menu {
            Button {
                self.onTapEditBudget()
            } label: {
                Label("予算を編集...", systemImage: "pencil")
            }
//            TODO: 実装
//            Button {} label: {
//                Label("予算を複製...", systemImage: "square.on.square")
//            }
//            TODO: 実装
//            Button {} label: {
//                Label("カテゴリを並び替え...", systemImage: "arrow.up.arrow.down")
//            }
            Button(role: .destructive) {
                self.onTapDeleteBudget()
            } label: {
                Label("予算を削除...", systemImage: "trash")
            }
            Divider()
            Button {
                self.onTapCreateBudget()
            } label: {
                Label("新しい予算を作成...", systemImage: "yensign.circle")
            }
            Button {
                self.onTapShowBudgetList()
            } label: {
                Label("予算一覧を表示", systemImage: "list.dash")
            }
            Divider()
            Button {
                self.onTapShowCategoryList()
            } label: {
                Label("カテゴリ一覧を表示", systemImage: "list.dash")
            }
        } label: {
            Button {} label: {
                Image(systemName: "ellipsis")
            }
            .accessibilityLabel("open menu")
        }
    }
}
