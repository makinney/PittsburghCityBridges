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
            VStack {
                menuBar()
                ScrollView {
                    LazyVStack(spacing: 2, pinnedViews: [.sectionHeaders]) {
                        ForEach(bridgeListViewModel.sections(groupedBy: bridgeInfoGrouping)) { bridgesSection in
                            Section {
                                ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                    if let imageURL = bridgeModel.imageURL {
                                        NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)) {
                                            SinglePhotoView(imageURL: imageURL, bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)
                                                .padding()
                                        }
                                    }
                                }
                                .font(.body)
                            } header: {
                                HStack {
                                    sectionLabel(bridgesSection.sectionName, bridgeInfoGrouping)
                                        .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                                        .font(.title3)
                                        .padding([.leading])
                                    Spacer()
                                }
                                .font(.headline)
                                .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                                .background(bridgesSection.pbColorPalate.textBgnd)
                            }
                            Divider()

                //            .background(bridgesSection.pbColorPalate.textBgnd)
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 10)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private func sectionLabel(_ sectionName: String, _ sectionListby: BridgeListViewModel.BridgeInfoGrouping) -> some View {
        
        switch sectionListby {
        case .neighborhood:
            Text("\(sectionName) Neighborhood")
        case .name:
            Text("Starting with \(sectionName)")
        case .year:
            Text("Built in \(sectionName)")
        }
    }
    
    
}

extension BridgePhotosView {
    
    private func menuBar() -> some View {
        HStack {
            Spacer()
            Text("Pittsburgh Bridges")
                .foregroundColor(.pbTitleTextFgnd)
                .font(.title)
            Spacer()
            sortMenu()
                .padding(.trailing, 10)
        }
        .background(Color.pbTitleTextBgnd)
    }
    
    private func sortMenu() -> some View {
        Menu(content: {
            Button {
                bridgeInfoGrouping = .name
            } label: {
                makeCheckedSortLabel("By Names", selectedSection: .name)
            }
            Button {
                bridgeInfoGrouping = .neighborhood
            } label: {
                makeCheckedSortLabel("By Neighborhoods", selectedSection: .neighborhood)
            }
            Button {
                bridgeInfoGrouping = .year
            } label: {
                makeCheckedSortLabel("By Year Built", selectedSection: .year)
            }
        }, label: {
            Label("Sort", systemImage: "rectangle.split.3x3")
                .labelStyle(.iconOnly)
        })
    }
    
    private func makeCheckedSortLabel(_ name: String, selectedSection: BridgeListViewModel.BridgeInfoGrouping) -> Label<Text, Image> {
        if self.bridgeInfoGrouping == selectedSection {
            return Label(name, systemImage: "checkmark.square.fill")
        } else {
            return Label(name, systemImage: "square")
        }
    }
}

struct SinglePhotoView: View {
    @State var bridgeImage = UIImage()
    @State var imageLoaded = false
    private var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let pbColorPalate: PBColorPalate
    private let imageURL: URL
    
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
                    .font(.caption)
                    .foregroundColor(pbColorPalate.textFgnd)
                    .padding([.leading, .trailing], 5)
                    .background(pbColorPalate.textBgnd)
            
                    .opacity(imageLoaded ? 1.0 : 0.0)
                Spacer()
            }
            ZStack {
                Image(uiImage: bridgeImage )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                BridgeImageLoadingProgressView(bridgeName: bridgeModel.name)
                    .opacity(imageLoaded ? 0.0 : 1.0)
            }
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
        BridgePhotosView(BridgeListViewModel(bridgeStore), bridgeInfoGrouping: .name)
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
