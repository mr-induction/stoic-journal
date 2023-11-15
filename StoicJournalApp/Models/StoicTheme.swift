//
//  Stoictheme.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/14/23.
//

import Foundation
import SwiftUI

struct StoicTheme {
    static let primaryFont = Font.custom("TimesNewRoman", size: 18)
    static let titleFont = Font.custom("TimesNewRoman-Bold", size: 24)

    static let primaryColor = Color(red: 112 / 255, green: 128 / 255, blue: 144 / 255) // Slate Gray
    static let secondaryColor = Color(red: 1, green: 1, blue: 240 / 255) // Ivory
    static let accentColor = Color(red: 204 / 255, green: 85 / 255, blue: 0) // Burnt Orange
    static let primaryTextColor = Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255) // Dark Charcoal
    static let secondaryTextColor = Color(red: 85 / 255, green: 85 / 255, blue: 85 / 255) // Dark Gray
}
