//
//  BridgeListRow.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/12/21.
//

import SwiftUI

struct BridgeListRow: View {
    @State private var bridgeImage = UIImage()
    @State private var imageLoaded = false
    private var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let imageURL: URL?
    private let imageFrameSize: CGSize
    private let imageStrokeWidth: CGFloat
    private let thumbNailWidth: CGFloat
    
    init(bridgeModel: BridgeModel) {
        self.bridgeModel = bridgeModel
        imageURL = bridgeModel.imageURL
        bridgeImageSystem = BridgeImageSystem()
        if UIDevice.current.userInterfaceIdiom == .phone {
            thumbNailWidth = 200
            imageFrameSize = CGSize(width: 50, height: 50)
            imageStrokeWidth = 1
        } else {
            thumbNailWidth = 500
            imageFrameSize = CGSize(width: 100, height: 100)
            imageStrokeWidth = 2
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(bridgeModel.name)
                    .font(.headline)
                Text("\(bridgeModel.neighborhoods())")
                    .font(.body)
                Text("Year Built: \(bridgeModel.yearBuilt)")
                    .font(.body)
                Spacer()
            }
            .multilineTextAlignment(.leading)
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "arrow.forward")
                    .foregroundColor(.accentColor)
                Spacer()
            }
        }
    }
}

struct BridgeListRow_Previews: PreviewProvider {
    static var previews: some View {
        BridgeListRow(bridgeModel: BridgeModel.preview)
        BridgeListRow(bridgeModel: BridgeModel.preview)
            .preferredColorScheme(.dark)
    }
}
