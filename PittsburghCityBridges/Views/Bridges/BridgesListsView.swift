//
//  BridgesView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/6/22.
//

import SwiftUI
import os

struct BridgesListsView: View {
    @AppStorage("bridgesListsView.searchCategory") private var searchCategory = BridgeSearcher.SearchCategory.neighborhood
    @AppStorage("bridgesListsView.showFavorites") private var showFavorites = false
    @EnvironmentObject var bridgeStore: BridgeStore
    @EnvironmentObject var favorites: Favorites
    @Namespace private var topID
    @State private var searchText = ""
    private var bridgeNotInApp = BridgeNotInApp()
    private var bridgeSearcher: BridgeSearcher
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgesListsView")
    
    init(_ bridgeSearcher: BridgeSearcher) {
        self.bridgeSearcher = bridgeSearcher
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TitleHeader(title: pageTitleText(searchCategory))
                    .padding(.bottom, 10)
                HeaderToolBar(searchCategory: $searchCategory,
                              showFavorites: $showFavorites,
                              searchText: $searchText)
                let bridgeModelCategories = bridgeSearcher.sortAndSearch(by: searchCategory,
                                                       searchText: searchText,
                                                       favorites: showFavorites ? favorites : nil)
                if !bridgeModelCategories.isEmpty {
                    ScrollViewReader { scrollViewReaderProxy in
                        ScrollView {
                            RefreshControlView(coordinateSpace: .named("RefreshControlView")) {
                                bridgeStore.refreshBridgeModels()
                            }
                            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                ForEach(bridgeModelCategories) { bridgeModelCategory in
                                    Section {
                                        ForEach(bridgeModelCategory.bridgeModels) { bridgeModel in
                                            NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, favorites: favorites)) {
                                                BridgeListRow(bridgeModel: bridgeModel)
                                                    .padding([.leading, .trailing])
                                            }
                                            Divider()
                                        }
                                        .id(topID)
                                    } header: {
                                        HStack {
                                            sectionLabel(bridgeModelCategory.name, searchCategory)
                                                .foregroundColor(Color.pbTextFnd)
                                                .font(.body)
                                                .padding([.leading])
                                                .padding([.top], 10)
                                                .padding([.bottom], 5)
                                            Spacer()
                                        }
                                    }
                                    .foregroundColor(Color.pbTextFnd)
                                    .background(Color.pbBgnd)
                                }
                            }
                        }
                        .coordinateSpace(name: "RefreshControlView")
                        .onChange(of: showFavorites, perform: { value in
                            if value == true {
                                scrollViewReaderProxy.scrollTo(topID)
                            }
                        })
                    }
                } else { // no search results
                    if !showFavorites {
                        if bridgeNotInApp.isFernHollowBridge(searchText) {
                            FernHollowUnsupportedView(searchText: $searchText)
                                .padding()
                        } else if let bridgeName = bridgeNotInApp.stateBridgeName(searchText) {
                            StateBridgeUnsupportedView(searchText: $searchText, bridgeName: bridgeName)
                                .padding()
                        }
                    } else {
                        VStack(alignment: .center) {
                            Spacer()
                            let msg = "No Favorites Found"
                            Text(msg)
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .background(Color.pbBgnd)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func pageTitleText(_ searchCategory: BridgeSearcher.SearchCategory) -> String {
        var title = "Pittsburgh City Bridges by"
        switch searchCategory {
        case .name:
            title += " Name"
        case .neighborhood:
            title += " Neighborhood"
        case .year:
            title += " Year Built"
        }
        return title
    }
    
    @ViewBuilder
    private func sectionLabel(_ sectionName: String, _ searchCategory: BridgeSearcher.SearchCategory) -> some View {
        switch searchCategory {
        case .neighborhood:
            Text("\(sectionName) \(AppTextCopy.SortedByCategory.neighborhood)")
        case .name:
            Text("\(sectionName) \(AppTextCopy.SortedByCategory.name)")
        case .year:
            Text("\(AppTextCopy.SortedByCategory.year) \(sectionName)")
        }
    }
}

struct BridgesView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static let favorites = Favorites()
    
    static var previews: some View {
        BridgesListsView(BridgeSearcher(bridgeStore))
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
        BridgesListsView(BridgeSearcher(bridgeStore))
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
