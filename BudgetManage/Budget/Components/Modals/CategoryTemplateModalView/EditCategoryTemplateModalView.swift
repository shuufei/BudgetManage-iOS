//
//  EditCategoryTemplateModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/09.
//

import SwiftUI

struct EditCategoryTemplateModalView: View {
    var categoryTemplate: CategoryTemplateCD

    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    @FetchRequest(entity: UICD.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) private var uiStateEntities: FetchedResults<UICD>

    @State private var initialized: Bool = false    
    @State private var theme: Theme = .red
    @State private var title: String = ""
    
    @State private var presentingConfirmationDialog: Bool = false
    private var isModified: Bool {
        get {
            return (
                self.categoryTemplate.title != self.title ||
                self.categoryTemplate.theme != self.theme
            )
        }
    }
    
    private func commit() {
        self.categoryTemplate.title = self.title
        self.categoryTemplate.themeName = self.theme.name
        self.uiStateEntities.first?.updatedAt = Date()
        try? self.viewContext.save()
        self.dismiss()
    }
    
    var body: some View {
        List {
            Section {
                TextField("カテゴリ名", text: self.$title)
                    .modifier(TextFieldClearButton(text: self.$title))
                ThemePicker(selection: self.$theme)
            }
            .onAppear {
                if self.initialized {
                    return
                }
                self.title = self.categoryTemplate.title ?? ""
                self.theme = self.categoryTemplate.theme
                self.initialized = true
            }
        }
        .navigationTitle("カテゴリの編集")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(isModified: self.isModified, onCommit: self.commit)
    }
}
