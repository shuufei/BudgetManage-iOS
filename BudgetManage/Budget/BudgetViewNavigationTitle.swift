//
//  NavigationViewTitle.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct BudgetViewNavigationTitle: View {
    let title: String
    private let iconSize: CGFloat = 15
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer().frame(width: self.iconSize)
            Text(title)
            Button(role: .none) {} label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: self.iconSize, height: 8)
            }
        }
    }
}

struct NavigationViewTitle_Previews: PreviewProvider {
    static var previews: some View {
        BudgetViewNavigationTitle(title: "title")
    }
}
