//
//  BridgePhotosView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct BridgePhotosView: View {
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
                            let imageLoader = UIImageLoader()
                            BridgeImageView(imageLoader: imageLoader, imageURL: bridgeModel.imageURL)
                                .padding()
                                .frame(minHeight: 100)
                                .clipped()
                        }
                    }
                }
                .navigationTitle("City Bridges")
            }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    struct BridgeImageView: View {
        @ObservedObject var imageLoader: UIImageLoader
        var imageURL: URL?
        var body: some View {
            switch imageLoader.state {
            case .idle:
                Color.clear
                    .onAppear {
                        imageLoader.load(imageURL)
                    }
            case .loading:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .failed(let error):
                Text(error)
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                //               .frame(height: 100)
            }
        }
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
