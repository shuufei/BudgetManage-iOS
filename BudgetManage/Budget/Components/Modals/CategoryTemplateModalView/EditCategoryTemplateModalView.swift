//
//  EditCategoryTemplateModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/09.
//

import SwiftUI

struct EditCategoryTemplateModalView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore

    var categoryTemplateId: UUID
    
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
                    if let categoryTemplate = self.categoryTemplateStore.categories.first(where: { $0.id == self.categoryTemplateId }) {
                        self.data = categoryTemplate
                        self.initialized = true
                    }
                }
            }
            .navigationTitle("カテゴリの編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        self.dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("保存") {
                        if let index = self.categoryTemplateStore.categories.firstIndex(where: { $0.id == self.categoryTemplateId }) {
                            self.categoryTemplateStore.categories[index] = self.data
                        }
                        self.dismiss()
                    }
                }
            }
        }
    }
}

struct EditCategoryTemplateModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryTemplateModalView(
            categoryTemplateId: CategoryTemplate.sampleData[0].id
        )
            .environmentObject(CategoryTemplateStore())
    }
}
