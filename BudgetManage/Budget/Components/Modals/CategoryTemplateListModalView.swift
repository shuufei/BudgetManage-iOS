//
//  CategoryListModalView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/05.
//

import SwiftUI

struct CategoryTemplateListModalView: View {
    @Binding var categoryTemplates: [CategoryTemplate]
    @Binding var showModalView: Bool
    @State var showCreateCategoryTemplateModalView: Bool = false

    var body: some View {
        NavigationView {
            List {
                if self.categoryTemplates.count == 0 {
                    HStack {
                        Spacer()
                        Text("カテゴリが登録されていません")
                        Spacer()
                    }
                    .listRowBackground(Color.red.opacity(0))
                }
                ForEach(self.categoryTemplates) { categoryTemplate in
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(categoryTemplate.theme.mainColor)
                            Text(categoryTemplate.title)
                                .padding(.all, 6)
                                .padding(.horizontal, 16)
                        }
                        .foregroundColor(categoryTemplate.theme.accentColor)
                        .fixedSize(horizontal: true, vertical: true)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
//                            self.showDeleteConfirmAlert = true
//                            self.deletionTarget = expense
                        } label: {
                            Text("削除")
                        }
                        Button(role: .none) {
//                            self.showEditModalView = true
//                            self.editTarget = expense
                        } label: {
                            Text("編集")
                        }
                        .tint(.gray)
                    }
                }
            }
            .navigationTitle("カテゴリ一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        self.showModalView = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showCreateCategoryTemplateModalView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: self.$showCreateCategoryTemplateModalView) {
                CreateCategoryTemplateModalView(showModalView: self.$showCreateCategoryTemplateModalView) { categoryTemplate in
                    self.categoryTemplates.append(categoryTemplate)
                }
            }
        }
    }
}

struct CategoryListModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTemplateListModalView(
            categoryTemplates: .constant([]),
            showModalView: .constant(true)
        )
    }
}
