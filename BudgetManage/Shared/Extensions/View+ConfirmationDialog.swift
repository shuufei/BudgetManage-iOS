//
//  View+ConfirmationDialog.swift
//  BudgetManage
//
//  Created by shufei hanashiro on 2023/01/06.
//

import SwiftUI

struct ConfirmationDialog: ViewModifier {
  @Environment(\.dismiss) private var dismiss
  @State private var presentingConfirmationDialog: Bool = false
  
  var isModified: Bool
  var onCancel: (() -> Void)?
  var onCommit: () -> Void
  
  private func doCancel() {
    onCancel?()
    dismiss()
  }
  
  private func doCommit() {
    onCommit()
    dismiss()
  }
  
  func body(content: Content) -> some View {
    NavigationView {
      content
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("キャンセル", role: .cancel) {
              if isModified {
                presentingConfirmationDialog.toggle()
              }
              else {
                doCancel()
              }
            }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("完了", action: doCommit)
          }
        }
        .confirmationDialog("", isPresented: $presentingConfirmationDialog) {
          Button("変更を破棄", role: .destructive, action: doCancel)
          Button("キャンセル", role: .cancel, action: { })
        } message: {
            Text("保存されていない変更があります")
        }
    }
    // Option 1: use a closure to handle the attempt to dismiss
//    .interactiveDismissDisabled(isModified) {
//      presentingConfirmationDialog.toggle()
//    }
    // Option 2: bind attempt to dismiss to a boolean state variable that drives the UI
    .interactiveDismissDisabled(isModified, attemptToDismiss: $presentingConfirmationDialog)
  }
}

extension View {
  func confirmationDialog(isModified: Bool, onCancel: (() -> Void)? = nil, onCommit: @escaping () -> Void) -> some View {
    self.modifier(ConfirmationDialog(isModified: isModified,  onCancel: onCancel, onCommit: onCommit))
  }
}
