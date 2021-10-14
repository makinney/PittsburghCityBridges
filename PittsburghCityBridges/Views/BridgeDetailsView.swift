//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import os

struct BridgeDetailsView: View {
    var bridgeViewModel: BridgeViewModel
    @State private var bridgeImage = UIImage(systemName: "photo") ?? UIImage()
    
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.bridgeService)
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Name: \(bridgeViewModel.name)")
                        .padding()
                    Image(uiImage: bridgeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding()
                        .frame(width: geometry.size.width)
                    VStack(alignment: .leading) {
                        Text("Built: \(bridgeViewModel.yearBuilt)")
                        Text("Rehab: \(bridgeViewModel.yearRehab)")
                        Text("Start: \(bridgeViewModel.startNeighborhood)")
                        Text("End: \(bridgeViewModel.endNeighborhood)")
                    }
                    .padding()
                }
            }
        }
        .task {
            if let url = bridgeViewModel.imageURL {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    bridgeImage = UIImage(data: data) ?? UIImage()
                } catch let error {
                    logger.error("\(error.localizedDescription)")
                }
            }
        }
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeViewModel: BridgeViewModel.preview)
    }
}
