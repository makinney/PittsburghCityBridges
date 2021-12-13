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
        ProgressView {
            Label("\(bridgeName)", systemImage: "arrow.down")
                .labelStyle(.titleOnly)
                .font(.caption)
        }
        .foregroundColor(.primary)
    }
}

struct BridgeImageLoadingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeImageLoadingProgressView(bridgeName: "name")
    }
}
