//
//  BudgetViewMenu.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetViewMenu: View {
    var body: some View {
        Menu {
            Button {} label: {
                Label("予算を複製...", systemImage: "square.on.square")
            }
            Button {} label: {
                Label("カテゴリを並び替え...", systemImage: "arrow.up.arrow.down")
            }
            Button(role: .destructive) {} label: {
                Label("予算を削除...", systemImage: "trash")
            }
            Divider()
            Button {} label: {
                Label("新しい予算を作成...", systemImage: "yensign.circle")
            }
            Button {} label: {
                Label("予算一覧を表示", systemImage: "list.dash")
            }
            Divider()
            Button {} label: {
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

struct BudgetViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        BudgetViewMenu()
    }
}
