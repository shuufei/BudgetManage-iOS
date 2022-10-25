//
//  Theme.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/09/06.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case red
    case poppy
    case orange
    case tan
    case oxblood
    case yellow
    case green
    case teal
    case sky
    case indigo
    case navy
    case periwinkle
    case purple
    case bubblegum
    case magenta
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .orange, .periwinkle, .poppy, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple, .red, .green: return .white
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
        case .red:
            return "レッド"
        case .green:
            return "グリーン"
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
        case .indigo:
            return "インディゴ"
        case .oxblood:
            return "オックスブラッド"
        case .periwinkle:
            return "ペリウィンクル"
        case .purple:
            return "パープル"
        case .bubblegum:
            return "バブルガム"
        }
    }
    var id: String {
        name
    }
}
