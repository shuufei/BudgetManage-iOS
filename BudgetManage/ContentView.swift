//
//  ContentView.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryTemplateStore: CategoryTemplateStore
    
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
        .task {
            do {
                self.budgetStore.budgets = try await BudgetStore.load()
                self.categoryTemplateStore.categories = try await CategoryTemplateStore.load()
                print(self.budgetStore.budgets.count)
            } catch {
                //                        TODO: handling error
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BudgetStore())
            .environmentObject(CategoryTemplateStore())
    }
}
