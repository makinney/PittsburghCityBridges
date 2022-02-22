//
//  CityBridgePalate.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/27/21.
//

import Foundation
import SwiftUI

struct PBColorPalate {
    var textFgnd: Color = Color(uiColor: UIColor.label)
    var textBgnd: Color = .pbTitleTextBgnd
    var titleTextFgnd: Color = .pbTitleTextFgnd
    var titleTextBgnd: Color = .pbTitleTextBgnd
}

class PBColorPalateSource {
    private var palates = [PBColorPalate]()
    private var palateIndex = 0
    
    init() {
//        palates.append(PBColorPalate(textFgnd:.pbTextFgndYellow, textBgnd: .pbTextBgndYellow))
//        palates.append(PBColorPalate(textFgnd:.pbTextFgndGreen, textBgnd: .pbTextBgndGreen))
//        palates.append(PBColorPalate(textFgnd:.pbTextFgndBrown, textBgnd: .pbTextBgndBrown))
        palates.append(PBColorPalate())
   //     palates.append(PBColorPalate(textFgnd:.pbTextFgndConcrete, textBgnd: .pbTextBgndConcrete))
    }
    
    func next() -> PBColorPalate {
        var pbColorPalate = PBColorPalate()
        if palateIndex >= palates.count {
            palateIndex = 0
        }
        pbColorPalate = palates[palateIndex]
        palateIndex += 1
        return pbColorPalate
    }
}
