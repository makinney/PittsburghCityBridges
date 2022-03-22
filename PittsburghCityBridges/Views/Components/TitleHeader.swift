//
//  TitleHeaderView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/31/21.
//

import SwiftUI

struct TitleHeader: View {
    var title: String = "Pittsburgh's City Bridges"

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .foregroundColor(Color.pbTextFnd)
                .font(.headline)
                .italic()
            Spacer()
        }
        .background(Color.pbBgnd)
    }
}

struct TitleHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TitleHeader()
        TitleHeader()
            .preferredColorScheme(.dark)
    }
}
