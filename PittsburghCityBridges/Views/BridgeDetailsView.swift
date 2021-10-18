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
                        .padding([.leading, .bottom])
                    let built = builtHistory()
                    if !built.isEmpty {
                        Text(built)
                            .padding([.leading, .bottom])
                    }
                    Text(neighborhoods())
                        .padding([.leading])
                    Image(uiImage: bridgeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .border(.foreground, width: 1)
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
        var neighborhood = "neighborhood"
        var description = "\(bridgeModel.startNeighborhood)"
        if let endNeighborhood = bridgeModel.endNeighborhood {
            description += " and \(endNeighborhood)"
            neighborhood += "s"
        }
        description += " " + neighborhood
        return description
    }
    
    private func builtHistory() -> String {
        var history = ""
        if !bridgeModel.yearBuilt.isEmpty {
            history = "Built in \(bridgeModel.yearBuilt)"
        }
        if !bridgeModel.yearRehab.isEmpty {
            history += " and rehabbed in \(bridgeModel.yearRehab)"
        }
        return history
    }
    
    private  func yearBuilt() -> String {
        var built = ""
        if !bridgeModel.yearBuilt.isEmpty {
            built = "\(bridgeModel.yearBuilt)"
        }
        return built
    }
    
    private func refurbished() -> String {
        var description = ""
        if !bridgeModel.yearRehab.isEmpty {
            description = "\(bridgeModel.yearRehab)"
        }
        return description
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview)
    }
}
