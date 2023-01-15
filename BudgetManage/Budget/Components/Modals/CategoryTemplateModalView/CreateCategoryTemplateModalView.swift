//
//  CreateCategoryTemplateModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/06.
//

import SwiftUI

struct CreateCategoryTemplateModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State var title: String = ""
    @State var colorSelection: Theme = .yellow
    var createCategoryTemplate: (_ categoryTemplate: CategoryTemplate) -> Void
    
    private func create() {
        self.createCategoryTemplate(CategoryTemplate(title: self.title, theme: self.colorSelection))
        self.dismiss()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("カテゴリ名", text: self.$title)
                        .modifier(TextFieldClearButton(text: self.$title))
                    ThemePicker(selection: self.$colorSelection)
                }
                Button {
                    self.create()
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "plus")
                        Text("作成")
                            .padding(.vertical, 4)
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(self.title.isEmpty)
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.black.opacity(0))
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("新規カテゴリ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.dismiss()
                    }
                }
            }
        }
    }
}
