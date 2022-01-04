//
//  MoreScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/3/22.
//

import SwiftUI

struct MoreScreenView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("More")
                .font(.title)
                .foregroundColor(Color.pbTextFgndYellow)
            Spacer()
        }
    }
}

struct MoreScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreenView()
            .preferredColorScheme(.dark)
    }
}
