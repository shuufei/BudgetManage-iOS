//
//  EditCategoryTemplateModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/09.
//

import SwiftUI

struct EditCategoryTemplateModalView: View {
    
    @Binding var categoryTemplate: CategoryTemplate
    @Binding var showModalView: Bool
    
    @State private var data: CategoryTemplate = CategoryTemplate(title: "", theme: .yellow)
    
    @State private var initialized: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("カテゴリ名", text: self.$data.title)
                        .modifier(TextFieldClearButton(text: self.$data.title))
                    ThemePicker(selection: self.$data.theme)
                }
                .onAppear {
                    if self.initialized {
                        return
                    }
                    self.data = self.categoryTemplate
                    self.initialized = true
                }
            }
            .navigationTitle("カテゴリの編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.showModalView = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("保存") {
                        self.categoryTemplate = self.data
                        self.showModalView = false
                    }
                }
            }
        }
    }
}

struct EditCategoryTemplateModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryTemplateModalView(
            categoryTemplate: .constant(CategoryTemplate(title: "dummy", theme: .yellow)),
            showModalView: .constant(true)
        )
    }
}
