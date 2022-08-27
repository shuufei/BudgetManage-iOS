//
//  AmountTextField.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import SwiftUI

struct AmountTextField: View {
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text("¥")
            TextField("0", text: self.$value)
                .modifier(TextFieldClearButton(text: self.$value))
                .keyboardType(.numberPad)
        }
    }
}

struct AmountTextField_Previews: PreviewProvider {
    static var previews: some View {
        AmountTextField(value: .constant("5000"))
    }
}
