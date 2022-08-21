//
//  BudgetEmptyView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetEmptyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            VStack(alignment: .center, spacing: 8) {
                Text("予算が登録されていません")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("予算を登録すると、任意の期間の\n予算を管理することができます。")
                    .foregroundColor(.secondary)
            }
            Button {} label: {
                Label("新しい予算を作成", systemImage: "yensign.circle")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct BudgetEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetEmptyView()
    }
}
