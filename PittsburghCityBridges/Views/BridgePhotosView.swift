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
                }
                .navigationTitle("Photos of Bridges")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SinglePhotoView: View {
    @State var bridgeImage = UIImage()
    @State var imageLoaded = false
    private var bridgeImageSystem: BridgeImageSystem
    private let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        bridgeImageSystem = BridgeImageSystem()
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: bridgeImage )
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
            ProgressView()
                .opacity(imageLoaded ? 0.0 : 1.0)
        }
        .onAppear {
            Task {
                do {
                    if let image = await bridgeImageSystem.getThumbnailImage(url:imageURL, size: CGSize(width: 1000, height: 1000)) {
                        bridgeImage = image
                        imageLoaded = true
                    }
                }
            }
        }
        .onDisappear {
            bridgeImage = UIImage()
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
