//
//  AddBudgetCategoryAlert.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/09.
//

import SwiftUI

struct AddBudgetCategoryAlert: UIViewControllerRepresentable {
    @Binding var textfieldText: String
    @Binding var showingAlert: Bool
      
    var budgetTitle: String
    var categoryTitle: String
    private let alertTitle: String = "カテゴリの追加"
    private var alertMessage: String {
        "\(self.budgetTitle)における\(categoryTitle)のカテゴリ予算を入力してください。"
    }
    
    var cancelButtonAction: () -> Void
    var addButtonAction: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        guard context.coordinator.alert == nil else{ return }
        
        if !self.showingAlert {
            return
        }

        let alert = UIAlertController(title: self.alertTitle, message: self.alertMessage, preferredStyle: .alert)
        context.coordinator.alert = alert
        
        alert.addTextField{ textField in
            textField.placeholder = "¥0"
            textField.text = self.textfieldText
            textField.delegate = context.coordinator
        }
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel) { _ in
            alert.dismiss(animated: true) {
                self.showingAlert = false
                self.cancelButtonAction()
            }
        })
        
        alert.addAction(UIAlertAction(title: "追加", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self.textfieldText = text
            }
            alert.dismiss(animated: true) {
                showingAlert = false
                addButtonAction()
            }
        })
        
        DispatchQueue.main.async {
            uiViewController.present(alert, animated: true, completion: {
                showingAlert = false
                context.coordinator.alert = nil
            })
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
      
        var alert: UIAlertController?
        var view: AddBudgetCategoryAlert
      
        init(_ view: AddBudgetCategoryAlert) {
            self.view = view
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.view.textfieldText = text.replacingCharacters(in: range, with: string)
            } else {
                self.view.textfieldText = ""
            }
            return true
        }
    }
}
