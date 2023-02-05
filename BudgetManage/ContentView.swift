//
//  ContentView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct ContentView: View {
    @State private var loading = false

    var body: some View {
        VStack {
            if !loading {
                BudgetView()
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
                
        }
    }
}
