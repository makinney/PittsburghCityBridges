//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import os

struct BridgeDetailsView: View {
    var bridgeModel: BridgeModel
    @State private var bridgeImage = UIImage(systemName: "photo") ?? UIImage()
    
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.bridgeStore)
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(bridgeModel.name)")
                        .font(.title)
                        .padding()
                    Image(uiImage: bridgeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width)
                    Text(neighborhoods())
                        .padding([.leading,.trailing, .top])
                    Text("Built: \(bridgeModel.yearBuilt)")
                        .padding([.leading,.trailing])
                    Text(refurbished())
                        .padding([.leading,.trailing])
                }
            }
            //           .padding()
        }
        .task {
            if let url = bridgeModel.imageURL {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    bridgeImage = UIImage(data: data) ?? UIImage()
                } catch let error {
                    logger.error("\(error.localizedDescription)")
                }
            }
        }
    }
    
    private func neighborhoods() -> String {
        var description = "Location: \(bridgeModel.startNeighborhood)"
        if let endNeighborhood = bridgeModel.endNeighborhood {
            description += " and \(endNeighborhood)"
        }
        return description
    }
    
    private func refurbished() -> String {
        var description = ""
        if let yearRehab = bridgeModel.yearRehab {
          description = "refurbished: \(yearRehab)"
        }
        return description
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview)
    }
}
