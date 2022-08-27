//
//  ColorTheme.swift
//  BudgetManage
//
//  Created by shuuhei hanashiro on 2022/08/27.
//

import Foundation
import SwiftUI

func getDefaultForegroundColor(_ colorScheme: ColorScheme) -> Color {
    colorScheme == .dark ? .white : .black
}

func getDefaultBackgroundColor(_ colorScheme: ColorScheme) -> Color {
    colorScheme == .dark ? .black : .white
}
