//
//  CityBridgePalate.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/27/21.
//

import Foundation
import SwiftUI

struct BridgeColorPalate {
    var listTextForeground: Color = Color(uiColor: UIColor.label)
    var listTextBackground: Color = Color(UIColor.secondarySystemBackground)
}

class BridgeColorPalates {
    private var palates = [BridgeColorPalate]()
    private var palateIndex = 0
    
    init() {
        palates.append(BridgeColorPalate(listTextForeground:.listTextForegroundYel, listTextBackground: .listTextBackgroundYel))
        palates.append(BridgeColorPalate(listTextForeground:.listTextForegroundGrn, listTextBackground: .listTextBackgroundGrn))
        palates.append(BridgeColorPalate(listTextForeground:.listTextForegroundBrn, listTextBackground: .listTextBackgroundBrn))

    }
    
    func getNext() -> BridgeColorPalate {
        var cityBridgePalate = BridgeColorPalate()
        if palateIndex >= palates.count {
            palateIndex = 0
        }
        cityBridgePalate = palates[palateIndex]
        palateIndex += 1
        return cityBridgePalate
    }
}
