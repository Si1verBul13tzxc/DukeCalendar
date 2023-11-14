/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

enum Theme: String{

    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow

    var accentColor: Color {
        switch self {
            case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky,
                .tan, .teal, .yellow:
                return .black
            case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }

    var mainColor: Color {
        Color(rawValue)
    }

    static subscript(n: Int) -> Theme { //Theme[2]
        let index = n % 16
        switch index {
            case 0: return .bubblegum
            case 1: return .buttercup
            case 2: return .indigo
            case 3: return .lavender
            case 4: return .magenta
            case 5: return .navy
            case 6: return .orange
            case 7: return .oxblood
            case 8: return .periwinkle
            case 9: return .poppy
            case 10: return .purple
            case 11: return .seafoam
            case 12: return .sky
            case 13: return .tan
            case 14: return .teal
            case 15: return .yellow
            default: return .bubblegum
        }
    }
}
