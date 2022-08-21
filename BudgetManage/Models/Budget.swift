//
//  Budget.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/21.
//

import Foundation

struct Budget: Hashable, Codable, Identifiable {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var budgetAmount: Int
    var isActive: Bool?
    
    init(title: String = "", startDate: Date, endDate: Date, budgetAmount: Int, isActibe: Bool = false) {
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
        self.budgetAmount = budgetAmount
        self.isActive = isActibe
        self.title = title
        if title.isEmpty {
            self.title = computedTitle(startDate: startDate, endDate: endDate)
        }
    }
    
    private func computedTitle(startDate: Date, endDate: Date) -> String {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "y年M月d日"
        startDateFormatter.locale = Locale(identifier: "ja_JP")

        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "M月d日"
        endDateFormatter.locale = Locale(identifier: "ja_JP")

//        年が異なる場合は、次の形式にする: YYYY年MM月DD日　−　YYYY年MM月DD日
        return "\(startDateFormatter.string(from: startDate)) − \(endDateFormatter.string(from: endDate))"
    }
}

let daySeconds: Double = 60 * 60 * 24;
extension Budget {
    static let sampleData = [
        Budget(title: "夏休み2022", startDate: Date(timeIntervalSince1970: 1660316400), endDate: Date(timeIntervalSince1970: 1660316400 + (daySeconds * 9)), budgetAmount: 30000, isActibe: false),
        Budget(startDate: Date(), endDate: Date(timeIntervalSinceNow: daySeconds * 31), budgetAmount: 150000, isActibe: true)
    ]
}
