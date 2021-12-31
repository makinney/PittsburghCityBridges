//
//  TitleHeaderView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/31/21.
//

import SwiftUI

struct TitleHeader: View {
    var pbColorPalate = PBColorPalate()
    var body: some View {
        HStack {
            Spacer()
            Text("Pittsburgh City Bridges")
                .foregroundColor(pbColorPalate.titleTextFgnd)
                .font(.title2)
                .italic()
            Spacer()
        }
        .background(pbColorPalate.titleTextBgnd)
    }
}

struct TitleHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TitleHeader()
    }
}
