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
    @State private var bridgeImage = UIImage()
    
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.bridgeStore)
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(bridgeModel.name)")
                        .font(.title)
                        .padding([.leading, .trailing, .bottom])
                    Text(neighborhoods())
                        .padding([.leading])
                    Text(yearBuilt())
                        .padding([.leading])
                    Text(refurbished())
                        .padding([.leading])
                    Image(uiImage: bridgeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .border(.foreground, width: 2)
                        .padding()
                        .frame(width: geometry.size.width)
                }
            }
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
    
    private  func yearBuilt() -> String {
        var built = ""
        if !bridgeModel.yearBuilt.isEmpty {
            built = "Built: \(bridgeModel.yearBuilt)"
        }
        return built
    }
    
    private func refurbished() -> String {
        var description = ""
        if !bridgeModel.yearRehab.isEmpty {
            description = "Refurbished: \(bridgeModel.yearRehab)"
        }
        return description
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview)
    }
}
