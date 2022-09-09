//
//  CategoryTemplateLabel.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/09.
//

import SwiftUI

struct CategoryTemplateLabel: View {
    var title: String
    var mainColor: Color
    var accentColor: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(self.mainColor)
                .frame(width: 24, height: 24)
                .foregroundColor(self.accentColor)
            Text(self.title)
                .foregroundColor(.primary)
        }
    }
}

struct CategoryTemplateLabel_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTemplateLabel(title: "", mainColor: .yellow, accentColor: .black)
    }
}
