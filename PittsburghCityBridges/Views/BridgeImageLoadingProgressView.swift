//
//  BridgeImageLoadingProgressView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/13/21.
//

import SwiftUI

struct BridgeImageLoadingProgressView: View {
    var bridgeName: String
    
    var body: some View {
        VStack {
            Text("Loading")
            ProgressView {
                Label("\(bridgeName)", systemImage: "arrow.down")
                    .labelStyle(.titleOnly)
            }
        }
        .foregroundColor(.primary)
        .font(.body)
    }
}

struct BridgeImageLoadingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeImageLoadingProgressView(bridgeName: "name")
    }
}
