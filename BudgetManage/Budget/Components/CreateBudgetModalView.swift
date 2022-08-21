//
//  CreateBudgetView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct CreateBudgetModalView: View {
    @Binding var isCreateMode: Bool
    @State var title: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var budgetAmount: Int = 0
    let onCreate: (_ newBudget: Budget.Data) -> Void
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.isLenient = true
        formatter.numberStyle = .currency
        formatter.currencyCode = "JPY"
        formatter.maximumFractionDigits = 0
        formatter.maximumIntegerDigits = 8
        return formatter
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("タイトル")) {
                    TextField("今月の予算", text: $title)
                }
                Section(header: Text("期間")) {
                    DatePicker(selection: $startDate, displayedComponents: .date) {
                        Text("開始日")
                            .foregroundColor(.secondary)
                    }
                    DatePicker(selection: $endDate, displayedComponents: .date) {
                        Text("終了日")
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text("予算額")) {
                    TextField("¥150,000", value: $budgetAmount, formatter: self.formatter)
                        .keyboardType(.numberPad)
                }
            }
                .navigationTitle("新規予算")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("キャンセル") {
                            self.isCreateMode = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("作成") {
                            let data = Budget.Data(title: self.title, startDate: self.startDate, endDate: self.endDate, budgetAmount: self.budgetAmount)
                            onCreate(data)
                            self.isCreateMode = false
                        }
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let data = Budget.Data()
                self.title = data.title
                self.startDate = data.startDate
                self.endDate = data.endDate
                self.budgetAmount = data.budgetAmount
            }
        }
    }
}

struct CreateBudgetModalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBudgetModalView(isCreateMode: .constant(true), onCreate: { newBudget in })
    }
}
