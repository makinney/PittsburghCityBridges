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
    @AppStorage("bridgePhotosView.bridgeInfoGrouping") private var bridgeInfoGrouping = BridgeListViewModel.BridgeInfoGrouping.neighborhood
    private var bridgeListViewModel: BridgeListViewModel

    init(_ bridgeListViewModel: BridgeListViewModel, bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping) {
        self.bridgeListViewModel = bridgeListViewModel
        self.bridgeInfoGrouping = bridgeInfoGrouping
    }
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TitleHeader(title: "City Bridges Photos")
                HeaderToolBar(bridgeInfoGrouping: $bridgeInfoGrouping)
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        ForEach(bridgeListViewModel.sections(groupedBy: bridgeInfoGrouping)) { bridgesSection in
                            Section {
                                ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                    if let imageURL = bridgeModel.imageURL {
                                        NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)) {
                                            SinglePhotoView(imageURL: imageURL, bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)
                                        }
                                    }
                                }
                                .font(.body)
                            } header: {
                                HStack {
                                    sectionLabel(bridgesSection.sectionName, bridgeInfoGrouping)
                                        .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                                        .font(.title2)
                                        .padding([.leading])
                                        .padding([.top], 10)
                                        .padding([.bottom], 5)
                                    Spacer()
                                }
                                .font(.headline)
                                .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                                .background(bridgesSection.pbColorPalate.textBgnd)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private func sectionLabel(_ sectionName: String, _ sectionListby: BridgeListViewModel.BridgeInfoGrouping) -> some View {
        
        switch sectionListby {
        case .neighborhood:
            Text("\(sectionName) \(PBText.SortedBySection.neighborhood) ")
        case .name:
            Text("\(sectionName) \(PBText.SortedBySection.name) ")
        case .year:
            Text("\(PBText.SortedBySection.year) \(sectionName)")
        }
    }
}

struct SinglePhotoView: View {
    @State var bridgeImage = UIImage()
    @State var imageLoaded = false
    private var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let pbColorPalate: PBColorPalate
    private let imageCornerRadius: CGFloat = 10
    private let imageURL: URL
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgePhotosView")

    init(imageURL: URL, bridgeModel: BridgeModel, pbColorPalate: PBColorPalate) {
        self.bridgeModel = bridgeModel
        self.pbColorPalate = pbColorPalate
        self.imageURL = imageURL
        bridgeImageSystem = BridgeImageSystem()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(bridgeModel.name)")
                    .font(.headline)
                    .foregroundColor(pbColorPalate.textFgnd)
                    .opacity(imageLoaded ? 1.0 : 0.0)
                Spacer()
            }
            ZStack {
                Image(uiImage: bridgeImage )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(imageCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: imageCornerRadius)
                            .stroke(Color.secondary, lineWidth: 2)
                    )
                    .opacity(imageLoaded ? 1.0 : 0.0)
                BridgeImageLoadingProgressView(bridgeName: bridgeModel.name)
                    .opacity(imageLoaded ? 0.0 : 1.0)
            }
        }
        .padding([.horizontal])
        .frame(width: UIScreen.main.bounds.size.width)
        .frame(height: UIScreen.main.bounds.size.width * 0.75)  // fraction of width
        .padding([.leading, .trailing, .bottom])
        .background(pbColorPalate.textBgnd)
        .onAppear {
            Task {
                do {
                    if imageLoaded == false {
                        if let image = await bridgeImageSystem.getThumbnailImage(url:imageURL, desiredThumbnailWidth: 1000) {
                            bridgeImage = image
                            imageLoaded = true
                        }
                    }
                }
            }
        }
        .onDisappear {
            bridgeImage = UIImage()
            imageLoaded = false
        }
    }
}

struct BridgePhotosView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        BridgePhotosView(BridgeListViewModel(bridgeStore), bridgeInfoGrouping: .name)
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
