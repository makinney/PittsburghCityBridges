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
    private var sectionListBy: BridgeListViewModel.SectionListBy = .neighborhood
    private var bridgeListViewModel: BridgeListViewModel

    init(_ bridgeListViewModel: BridgeListViewModel, sectionListBy: BridgeListViewModel.SectionListBy = .name) {
        self.bridgeListViewModel = bridgeListViewModel
        self.sectionListBy = sectionListBy
        //      UITableView.appearance().backgroundColor = .green
    }
    
    var body: some View {
        NavigationView {
                ScrollView {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        ForEach(bridgeListViewModel.sectionList(sectionListBy)) { bridgesSection in
                            Section {
                                ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                    if let imageURL = bridgeModel.imageURL {
                                        NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, bridgeColorPalate: bridgesSection.bridgeColorPalate)) {
                                            SinglePhotoView(imageURL: imageURL, bridgeModel: bridgeModel)
                                                .padding()
                                        }
                                    }
                                }
                                //               .background(Color("SteelersBlack"))
                                .font(.body)
                            } header: {
                                HStack {
                                    Spacer()
                                    Text("\(bridgesSection.sectionName)")
                                        .foregroundColor(Color("SteelersGold"))

                                    Spacer()
                                }
                                .background(Color("SteelersBlack"))
                       //         .background(Color.white)
                            }
                        }
                    }
                    
                }
                .padding([.leading, .trailing], 10)
                .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SinglePhotoView: View {
    @State var bridgeImage = UIImage()
    @State var imageLoaded = false
    private var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let imageURL: URL
    
    init(imageURL: URL, bridgeModel: BridgeModel) {
        self.bridgeModel = bridgeModel
        self.imageURL = imageURL
        bridgeImageSystem = BridgeImageSystem()
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: bridgeImage )
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack {
                HStack {
                    Spacer()
                    Text("\(bridgeModel.name)")
                        .font(.caption)
                        .foregroundColor(Color("SteelersGold"))
                        .padding([.leading, .trailing], 5)
                        .background(Color("SteelersBlack"))
                        .opacity(imageLoaded ? 1.0 : 0.0)
                    Spacer()
                }
                .padding(4)
                Spacer()
            }
            BridgeImageLoadingProgressView(bridgeName: bridgeModel.name)
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
        BridgePhotosView(BridgeListViewModel(bridgeStore))
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
