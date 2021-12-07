//
//  BridgePhotosView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI
import os

struct BridgePhotosView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @ObservedObject private var imageLoader: UIImageLoader
    private let fileServices: FileServices
    
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgePhotosView")
    init() {
        do {
            try fileServices = FileServices()
        } catch {
            fatalError("failed to create file services \(error.localizedDescription)")
        }
        imageLoader = UIImageLoader(fileServices: fileServices)
    }
    
    private func makeImage(_ bridgeModel: BridgeModel, imageLoader: UIImageLoader) -> UIImage {
        var image: UIImage?
        if let data  = imageLoader.uiBridgeImages[imageLoader.imageFileName(bridgeModel.imageURL)] {
            image = UIImage(data: data)
        }
        return image ?? UIImage()
    }
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(bridgeStore.bridgeModels) { bridgeModel in
                            NavigationLink(destination: BridgeDetailsView(fileServices: fileServices, bridgeModel: bridgeModel)) {
                                Image(uiImage: makeImage(bridgeModel, imageLoader: imageLoader))
                                        .resizable()
                                        .scaledToFill()
                                    .frame(maxWidth: geometry.size.width)
                                    .onAppear {
                                        imageLoader.loadBridgeImage(for: bridgeModel.imageURL)
                                    }
                                
                            }
                        }
                    }
                    .navigationTitle("Photos of Bridges")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct BridgePhotosView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        Text("BridgePhotosView_Previews needs code")
//        BridgePhotosView(imageLoader: UIImageLoader(FileServices()))
//            .environmentObject(bridgeStore)
//            .onAppear {
//                bridgeStore.preview()
//            }
    }
}



//// this hangs up loading photos
// struct BridgePhotosViewByGroup: View {
//     let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgePhotosView")
//
//     @EnvironmentObject var bridgeStore: BridgeStore
//     var imageLoader: UIImageLoader = UIImageLoader()
//     var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
//     var body: some View {
//         NavigationView {
//             GeometryReader { geometry in
//                 ScrollView {
//                     ForEach(bridgeStore.groupByNeighborhood()) { bridgeGroup in
//                         Section("\(bridgeGroup.groupName)") {
//                             LazyVGrid(columns: columns) {
//                                 ForEach(bridgeGroup.bridgeModels) { bridgeModel in
//                                     NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
//                                         BridgeImageView(bridgeModel.imageURL, options: [.scaleDownLargeImages])
//                                             .scaledToFill()
//                                             .frame(maxWidth: geometry.size.width)
//                                     }
//                                 }
//                             }
//                         }
//
//                     }
//        //             .navigationTitle("City Bridges")
//                 }
//             }
//         }
//         .navigationViewStyle(StackNavigationViewStyle())
//     }
// }
//
//
