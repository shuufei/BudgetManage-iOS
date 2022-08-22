//
//  NumbersOnly.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/22.
//

import Foundation

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
