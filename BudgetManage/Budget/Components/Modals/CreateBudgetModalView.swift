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
    @ObservedObject var budgetAmount = NumbersOnly()
    let onCreate: (_ newBudget: Budget.Data) -> Void
    
    private var isDisabled: Bool {
        return self.title.isEmpty
    }
    
    private func create() {
        let data = Budget.Data(title: self.title, startDate: self.startDate, endDate: self.endDate, budgetAmount: Int(self.budgetAmount.value) ?? 0)
        onCreate(data)
        self.isCreateMode = false
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("タイトル")) {
                    TextField("今月の予算", text: $title)
                        .modifier(TextFieldClearButton(text: $title))
                }
                Section(header: Text("期間")) {
                    DatePicker(selection: $startDate, displayedComponents: .date) {
                        Text("開始日")
                            .foregroundColor(.secondary)
                    }
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    DatePicker(selection: $endDate, displayedComponents: .date) {
                        Text("終了日")
                            .foregroundColor(.secondary)
                    }
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                }
                Section(header: Text("予算額")) {
                    AmountTextField(value: $budgetAmount.value)
                }
                Button {
                    self.create()
                } label: {
                    Text("作成")
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                }
                .disabled(self.isDisabled)
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.red.opacity(0))
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("新規予算")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
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
            }
        }
    }
}

struct CreateBudgetModalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBudgetModalView(isCreateMode: .constant(true), onCreate: { newBudget in })
    }
}
