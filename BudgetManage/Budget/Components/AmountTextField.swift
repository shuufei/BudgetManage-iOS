//
//  AmountTextField.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import SwiftUI

fileprivate struct AppendExpenseButton: View {
    let amount: Int
    var theme: Theme?
    let action: () -> Void
    var body: some View {
        Button {
            self.action()
        } label: {
            Label("¥\(self.amount)", systemImage: "plus")
                .frame(maxWidth: .infinity)
                .foregroundColor(self.theme?.mainColor ?? .primary)
        }
        .tint(self.theme?.mainColor ?? .primary)
    }
}

struct AmountTextField: View {
    @Binding var value: String
    
    var theme: Theme?
    
    var body: some View {
        HStack {
            Text("¥")
            TextField("0", text: self.$value)
                .modifier(TextFieldClearButton(text: self.$value, theme: self.theme))
                .keyboardType(.numberPad)
        }
        VStack {
            HStack {
                AppendExpenseButton(amount: 10000, theme: self.theme) {
                    if let current = Int(self.value) {
                        self.value =  String(current + 10000)
                    } else {
                        self.value = String(10000)
                    }
                }
                AppendExpenseButton(amount: 5000, theme: self.theme) {
                    if let current = Int(self.value) {
                        self.value =  String(current + 5000)
                    } else {
                        self.value = String(5000)
                    }
                }
            }
            HStack {
                AppendExpenseButton(amount: 1000, theme: self.theme) {
                    if let current = Int(self.value) {
                        self.value =  String(current + 1000)
                    } else {
                        self.value = String(1000)
                    }
                }
                AppendExpenseButton(amount: 500, theme: self.theme) {
                    if let current = Int(self.value) {
                        self.value =  String(current + 500)
                    } else {
                        self.value = String(500)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .buttonStyle(.bordered)
    }
}

struct AmountTextField_Previews: PreviewProvider {
    static var previews: some View {
        AmountTextField(value: .constant("5000"))
    }
}
