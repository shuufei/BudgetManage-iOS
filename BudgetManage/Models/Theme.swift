//
//  Theme.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/06.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case yellow
    case orange
    case magenta
    case navy
    case sky
    case poppy
    case tan
    case teal
    case buttercup
    case indigo
    case lavender
    case oxblood
    case periwinkle
    case purple
    case seafoam
    case bubblegum
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue.capitalized
    }
    var kana: String {
        switch self {
        case .yellow:
            return "イエロー"
        case .orange:
            return "オレンジ"
        case .magenta:
            return "マジェンダ"
        case .navy:
            return "ネイビー"
        case .sky:
            return "スカイブルー"
        case .poppy:
            return "ポピーレッド"
        case .tan:
            return "タン"
        case .teal:
            return "ティールブルー"
        case .buttercup:
            return "バターカップ"
        case .indigo:
            return "インディゴ"
        case .lavender:
            return"ラベンダー"
        case .oxblood:
            return "オックスブラッド"
        case .periwinkle:
            return "ペリウィンクル"
        case .purple:
            return "パープル"
        case .seafoam:
            return "シーフォームグリーン"
        case .bubblegum:
            return "バブルガム"
        }
    }
    var id: String {
        name
    }
}
