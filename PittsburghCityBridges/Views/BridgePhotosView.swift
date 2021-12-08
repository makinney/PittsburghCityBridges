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
    
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgePhotosView")
    init() {
    }
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(bridgeStore.bridgeModels) { bridgeModel in
                            if let imageURL = bridgeModel.imageURL {
                                NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
                                    SinglePhotoView(imageURL: imageURL)
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

struct SinglePhotoView: View {
    @ObservedObject private var imageLoader: UIImageLoader
    private let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        imageLoader = UIImageLoader()
    }
    private func makeImage(_ imageURL: URL, imageLoader: UIImageLoader) -> UIImage {
        var image: UIImage?
        if let data  = imageLoader.uiBridgeImages[imageLoader.imageFileName(imageURL)] {
            image = UIImage(data: data)?.preparingThumbnail(of: CGSize(width: 500, height: 500)) // TODO: calculate ideal size based on device?
        }
        return image ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: makeImage(imageURL, imageLoader: imageLoader))
            .resizable()
            .aspectRatio(1.0, contentMode: .fill)
            .onAppear {
                imageLoader.loadBridgeImage(for: imageURL)
            }
    }
}

struct BridgePhotosView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        Text("BridgePhotosView_Previews needs code")
                BridgePhotosView()
                    .environmentObject(bridgeStore)
                    .onAppear {
                        bridgeStore.preview()
                    }
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
