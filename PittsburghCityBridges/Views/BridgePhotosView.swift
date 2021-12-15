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
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                List {
                    ForEach(bridgeListViewModel.sectionList(sectionListBy)) { bridgesSection in
                        Section("\(bridgesSection.sectionName)") {
                       //     LazyVGrid(columns: columns) {
                                ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                    if let imageURL = bridgeModel.imageURL {
                                        NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
                                            SinglePhotoView(imageURL: imageURL, bridgeModel: bridgeModel)
                                        }
                                    }
                                }
                       //     }
                            //               .background(Color("SteelersBlack"))
                            .font(.body)
                        }
                        //            .listRowBackground(Color.orange)
                        //           .background(Color.purple)
                        .font(.headline)
                    }
                }
            .listStyle(.grouped)
            .navigationTitle(makeNavigationTitle(for: sectionListBy))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                ScrollView {
//                    LazyVGrid(columns: columns) {
//                        ForEach(bridgeStore.bridgeModels) { bridgeModel in
//                            if let imageURL = bridgeModel.imageURL {
//                                NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
//                                    SinglePhotoView(imageURL: imageURL, bridgeModel: bridgeModel)
//                                }
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Bridge Photos")
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
    private func makeNavigationTitle(for selectedSection: BridgeListViewModel.SectionListBy) -> String {
        var title = ""
        switch selectedSection {
        case .name:
            title = "by Name"
        case .neighborhood:
            title = "by Location"
        case .year:
            title = "by Year Built"
        }
        return title
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
                Spacer()
                HStack {
                    Text("\(bridgeModel.name)")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .background(.ultraThinMaterial)
                        .opacity(imageLoaded ? 1.0 : 0.0)
                    Spacer()
                }
                .padding(4)
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
