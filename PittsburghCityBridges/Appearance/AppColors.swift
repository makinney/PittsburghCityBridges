//
//  AppColors.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/21/21.
//

import SwiftUI
import UIKit

extension Color {
    static let pbTextFnd = Color(light: Asset.bridgeBlackA, dark: Asset.bridgeYellowA)
    static let pbTitleTextBgnd =  Color(light: Asset.bridgeGreenA , dark: Asset.bridgeBlackA)
    static let creditscreenBgnd = Color(light: Asset.bridgeYellowA , dark: Asset.bridgeBlackA)
}

extension UIColor {
    static let pbTabBarBackground = UIColor(light: Asset.bridgeYellowA, dark: Asset.bridgeBlackA)
    static let accentColor = UIColor(named: "AccentColor") ?? UIColor.yellow  // There is also a Color.accentColor define by SwiftUI
}

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
    static var bridgeConcreteA = UIColor(named: "bridgeConcreteA") ?? UIColor.gray
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
