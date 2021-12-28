//
//  CityBridgeColors.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/21/21.
//

import SwiftUI
import UIKit

struct AssetColors {
    static var steelerGold = UIColor(named: "SteelersGold") ?? UIColor.yellow
    static var steelerBlack = UIColor(named: "SteelersBlack") ?? UIColor.black
    
    static var bBa = UIColor(named: "bridgeBlueA") ?? UIColor.yellow
    static var bBb = UIColor(named: "bridgeBlueB") ?? UIColor.yellow

    static var bYa = UIColor(named: "bridgeYellowA") ?? UIColor.yellow
    static var bYb = UIColor(named: "bridgeYellowB") ?? UIColor.yellow
    static var bGa = UIColor(named: "bridgeGreenA") ?? UIColor.green
    static var bGb = UIColor(named: "bridgeGreenB") ?? UIColor.green
    static var bGc = UIColor(named: "bridgeGreenC") ?? UIColor.green

    static var bBrownA = UIColor(named: "bridgeBrownA") ?? UIColor.brown
    static var bBrownB = UIColor(named: "bridgeBrownB") ?? UIColor.brown

    static var bBrownC = UIColor(named: "bridgeBrownC") ?? UIColor.brown

    static var congreteA = UIColor(named: "congreteA") ?? UIColor.gray

}

extension Color {
    static let listTextForegroundBrn = Color(light: AssetColors.steelerBlack, dark: AssetColors.bBrownA)
    static let listTextBackgroundBrn = Color(light: AssetColors.bBrownA, dark: AssetColors.steelerBlack)
    static let listTextForegroundGrn = Color(light: AssetColors.steelerBlack, dark: AssetColors.bGa)
    static let listTextBackgroundGrn = Color(light: AssetColors.bGa, dark: AssetColors.steelerBlack)
    static let listTextForegroundYel = Color(light: AssetColors.steelerBlack, dark: AssetColors.bYa)
    static let listTextBackgroundYel = Color(light: AssetColors.bYa, dark: AssetColors.steelerBlack)
    
    static let listTextForegroundCongrete = Color(light: AssetColors.steelerBlack, dark: AssetColors.congreteA)
    static let listTextBackgroundCongrete = Color(light: AssetColors.congreteA, dark: AssetColors.steelerBlack)
    
    static let titleTextFgnd =  Color(light: UIColor.label , dark: AssetColors.bYa)
    static let titleTextBkgnd =  Color(light: UIColor.tertiarySystemBackground , dark: AssetColors.steelerBlack)
    static let steelerBlack = Color(uiColor: AssetColors.steelerBlack)
}

extension Color {
    // dyanmic Colors for light and dark modes
    //
    // make dynamnic Color from Color types
    init(light: Color, dark: Color) {
        self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
    
    // make dynamnic Color from UIColor types
    init(light: UIColor, dark: UIColor) {
        self.init(UIColor(light: light, dark: dark))
    }
}

extension UIColor {
    // the UIKIt dynamicProvider
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return light
            case .dark:
                return dark
            @unknown default:
                return light
            }
        }
    }
}
