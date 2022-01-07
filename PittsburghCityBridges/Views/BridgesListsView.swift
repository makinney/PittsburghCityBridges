//
//  BridgesView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/6/22.
//

import SwiftUI
import os

struct BridgesListsView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @EnvironmentObject var favorites: Favorites
    @AppStorage("bridgesListsView.bridgeInfoGrouping") private var bridgeInfoGrouping = BridgeListViewModel.BridgeInfoGrouping.neighborhood
    @AppStorage("bridgesListsView.onlyShowFavorites") private var onlyShowFavorites = false
    private var bridgeListViewModel: BridgeListViewModel
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgesListsView")
    
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
                TitleHeader(title: "Pittsburgh City Bridges")
                HeaderToolBar(bridgeInfoGrouping: $bridgeInfoGrouping, onlyShowFavorites: $onlyShowFavorites)
                let sections = bridgeListViewModel.sections(groupedBy: bridgeInfoGrouping)
                let filterSections = onlyShowFavorites ?  bridgeListViewModel.filter(sections: sections, favorites: favorites) : sections
                if !filterSections.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            ForEach(filterSections) { bridgesSection in
                                Section {
                                    ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                        NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate, favorites: favorites)) {
                                            BridgeListRow(bridgeModel: bridgeModel)
                                                .padding([.leading, .trailing])
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
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        let msg = onlyShowFavorites ? "No Favorites Found" : ""
                        Text(msg)
                        Spacer()
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
    static let favorites = Favorites()
    
    static var previews: some View {
        BridgesListsView(BridgeListViewModel(bridgeStore))
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
        BridgesListsView(BridgeListViewModel(bridgeStore))
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
