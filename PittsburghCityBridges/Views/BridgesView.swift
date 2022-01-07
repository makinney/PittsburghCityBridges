//
//  BridgesView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/6/22.
//

import SwiftUI
import os

struct BridgesView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @EnvironmentObject var favorites: PersistedSet
    @AppStorage("bridgeListView.bridgeInfoGrouping") private var bridgeInfoGrouping = BridgeListViewModel.BridgeInfoGrouping.neighborhood
    @AppStorage("bridge.onlyShowFavorites") private var onlyShowFavorites = false
    private var bridgeListViewModel: BridgeListViewModel
    enum DisplayMode {
        case list
        case photos
    }
    private var displayMode = DisplayMode.list
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgePView")

    init(_ bridgeListViewModel: BridgeListViewModel, bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping) {
        self.bridgeListViewModel = bridgeListViewModel
        self.bridgeInfoGrouping = bridgeInfoGrouping
    }
    
    init(_ bridgeListViewModel: BridgeListViewModel, displayMode: DisplayMode = .list) {
        self.bridgeListViewModel = bridgeListViewModel
        self.displayMode = displayMode
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TitleHeader(title: displayMode == .list ? "Pittsburgh City Bridges" : "Photos")
                HeaderToolBar(bridgeInfoGrouping: $bridgeInfoGrouping, onlyShowFavorites: $onlyShowFavorites)
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        let sections = bridgeListViewModel.sections(groupedBy: bridgeInfoGrouping)
                        let filterSections = onlyShowFavorites ?  bridgeListViewModel.filter(sections: sections, favorites: favorites) : sections
                        ForEach(filterSections) { bridgesSection in
                            Section {
                                ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                    NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate, favorites: favorites)) {
                                        if displayMode == .list {
                                            BridgeListRow(bridgeModel: bridgeModel)
                                                .padding([.leading, .trailing])
                                        } else {
                                            if let imageURL = bridgeModel.imageURL {
                                                SinglePhotoView(imageURL: imageURL, bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)
                                            }
                                        }
                                    }
                                    Divider()
                                }
                            } header: {
                                HStack {
                                    sectionLabel(bridgesSection.sectionName, bridgeInfoGrouping)
                                        .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                                        .font(.title3)
                                        .padding([.leading])
                                        .padding([.top], 10)
                                        .padding([.bottom], 5)
                                    Spacer()
                                }
                            }
                            .font(.headline)
                            .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                            .background(bridgesSection.pbColorPalate.textBgnd)
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

struct BridgesView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static let favorites = PersistedSet()
    
    static var previews: some View {
        BridgesView(BridgeListViewModel(bridgeStore))
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
        BridgesView(BridgeListViewModel(bridgeStore))
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
