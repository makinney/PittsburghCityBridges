//
//  BridgePhotosView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI
import SDWebImageSwiftUI
import os

struct BridgePhotosView: View {
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgePhotosView")
    
    @EnvironmentObject var bridgeStore: BridgeStore
    var imageLoader: UIImageLoader = UIImageLoader()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack {
                        ForEach(bridgeStore.bridgeModels) { bridgeModel in
                            if let imageURL = bridgeModel.imageURL {
                                let content = Content(tag: bridgeModel.id, url: imageURL)
                                LazyReleaseableWebImage {
                                    WebImage(url: content.url)
                                        .resizable()
                                        .placeholder {
                                            ProgressView()
                                        }
                                } placeholder: {
                                    ProgressView()
                                }
                                .scaledToFill()
                                .frame(width: geometry.size.width)
                            }
                            
                            //     WebImage(url: content.url)
                            
                            //                        NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
                            //                            BridgeImageView(bridgeModel.imageURL)
                            //                                .scaledToFill()
                            //           //                     .frame(maxWidth: geometry.size.width)
                            //                        }
                        }
                    }
                    .navigationTitle("City Bridges")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct BridgePhotosView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        BridgePhotosView()
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
