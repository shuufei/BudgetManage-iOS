//
//  CategoryTitle.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/29.
//

import SwiftUI

struct CategoryTitle: View {
    var categoryTitle: String
    var categoryBalanceAmount: Int32

    @Environment(\.colorScheme) private var colorScheme
    
    private var isDeficit: Bool {
        self.categoryBalanceAmount < 0
    }
    
    var body: some View {
        HStack {
            Text(self.categoryTitle)
                .font(.headline)
            Spacer()
            HStack {
                Text("残り")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("¥\(self.categoryBalanceAmount)")
                    .font(.headline)
                    .foregroundColor(self.isDeficit ? .red : getDefaultForegroundColor(self.colorScheme))
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.white.opacity(0))
        .padding(.horizontal, 12)
    }
}
