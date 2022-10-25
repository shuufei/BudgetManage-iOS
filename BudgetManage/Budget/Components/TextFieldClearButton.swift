//
//  TextFieldClearButton.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/22.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    var theme: Theme?
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "delete.left")
                }
                .tint(self.theme?.mainColor ?? .blue)
            }
        }
    }
}
