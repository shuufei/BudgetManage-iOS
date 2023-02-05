//
//  CategoryBudgetBar.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/03.
//

import SwiftUI

struct CategoryBudgetBar: View {
    var budgetAmount: Int32
    var budgetBalanceAmount: Int32
    var mainColor: Color
    
    @State private var totalHeight = CGFloat(0)
    private let barHeight: CGFloat = 20

    @State private var showBar = false
    
    private var balanceAmountRate: CGFloat {
        let rate = CGFloat(self.budgetBalanceAmount) / CGFloat(self.budgetAmount)
        return rate.isNaN || (!rate.isNaN && rate < 0) ? 0 : rate
    }

    private func getBalanceAmountBarWidth(_ geometryWidth: CGFloat) -> CGFloat {
        let width = geometryWidth;
        return width >= 0 ? width * self.balanceAmountRate : 0;
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 2) {
                ZStack {
                    self.mainColor
                        .frame(width: self.showBar ? self.getBalanceAmountBarWidth(geometry.size.width) : 0, height: self.barHeight)
                        .animation(.spring().delay(0.3), value: showBar)
                }
                
                .frame(width: geometry.size.width, height: self.barHeight, alignment: .leading)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(3)
                HStack {
                    Text("¥0")
                    Spacer()
                    Text("¥\(self.budgetAmount)")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .background(GeometryReader { gp -> Color in
                DispatchQueue.main.async {
                    self.totalHeight = gp.size.height
                }
                return Color.clear
            })

        }
        .frame(height: self.totalHeight)
        .onAppear {
            self.showBar = true
        }
    }
}
