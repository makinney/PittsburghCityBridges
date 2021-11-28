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
                    LazyVGrid(columns: columns) {
                        ForEach(bridgeStore.bridgeModels) { bridgeModel in
                            NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
                                BridgeImageView(bridgeModel.imageURL, options: [.scaleDownLargeImages])
                                    .scaledToFill()
                                    .frame(maxWidth: geometry.size.width)
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
