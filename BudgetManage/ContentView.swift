//
//  ContentView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = BudgetStore()

    var body: some View {
        TabView {
            BudgetView(budgets: $store.budgets)
                .tabItem {
                    Label("予算", systemImage: "yensign.circle")
                }
            LogView()
                .tabItem {
                    Label("出費履歴", systemImage: "list.bullet")
                }
        }
        .task {
            do {
                store.budgets = try await BudgetStore.load()
                print(store.budgets.count)
            } catch {
//                        TODO: handling error
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
