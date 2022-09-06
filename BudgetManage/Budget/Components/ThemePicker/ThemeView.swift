//
//  ThemeView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/06.
//

import SwiftUI

struct ThemeView: View {
    let theme: Theme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(theme.mainColor)
            Text(theme.kana)
                .padding(.all, 6)
                .padding(.horizontal, 24)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: true, vertical: true)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: .yellow)
    }
}
