//
//  ContentView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BudgetView(budget: Budget.sampleData[0])
                .tabItem {
                    Label("予算", systemImage: "yensign.circle")
                }
            LogView()
                .tabItem {
                    Label("出費履歴", systemImage: "list.bullet")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
