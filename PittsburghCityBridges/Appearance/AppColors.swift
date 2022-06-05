//
//  AppColors.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/21/21.
//

import SwiftUI
import UIKit

private struct Asset {
    static var bridgeBlackA = UIColor(named: "bridgeBlackA") ?? UIColor.black
    static var bridgeBlueA = UIColor(named: "bridgeBlueA") ?? UIColor.yellow
    static var bridgeBlueB = UIColor(named: "bridgeBlueB") ?? UIColor.yellow
    static var bridgeYellowA = UIColor(named: "bridgeYellowA") ?? UIColor.yellow
    static var bridgeYellowB = UIColor(named: "bridgeYellowB") ?? UIColor.yellow
    static var bridgeGreenA = UIColor(named: "bridgeGreenA") ?? UIColor.green
    static var bridgeGreenB = UIColor(named: "bridgeGreenB") ?? UIColor.green
    static var bridgeGreenC = UIColor(named: "bridgeGreenC") ?? UIColor.green
    static var bridgeBrownA = UIColor(named: "bridgeBrownA") ?? UIColor.brown
    static var bridgeBrownB = UIColor(named: "bridgeBrownB") ?? UIColor.brown
    static var bridgeBrownC = UIColor(named: "bridgeBrownC") ?? UIColor.brown
    static var launchScreenText = UIColor(named: "launchScreenText") ?? UIColor.label
    static var launchScreenBackground = UIColor(named: "launchScreenBackground") ?? UIColor.label

}

extension Color {
    static let pbTextFnd = Color(light: Asset.bridgeBlackA, dark: Asset.bridgeYellowB)
    static let pbBgnd =  Color(light: Asset.bridgeYellowB , dark: Asset.bridgeBlackA)
}

extension UIColor {
    static let accentColor = UIColor(named: "AccentColor") ?? UIColor.yellow  // There is also a Color.accentColor define by SwiftUI
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
