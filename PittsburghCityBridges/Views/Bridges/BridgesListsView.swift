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
    @AppStorage("bridgesListsView.bridgeInfoGrouping") private var bridgeInfoGrouping = BridgeSearcher.BridgeInfoGrouping.neighborhood
    @AppStorage("bridgesListsView.showFavorites") private var showFavorites = false
    @Namespace private var topID
    @State private var searchText = ""
    private var bridgeSearcher: BridgeSearcher
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgesListsView")
    
    init(_ bridgeSearcher: BridgeSearcher) {
        self.bridgeSearcher = bridgeSearcher
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TitleHeader(title: pageTitleText(bridgeInfoGrouping))
                    .padding(.bottom, 10)
                HeaderToolBar(bridgeInfoGrouping: $bridgeInfoGrouping,
                              showFavorites: $showFavorites,
                              searchText: $searchText)
                let sections = bridgeSearcher.sections(groupedBy: bridgeInfoGrouping,
                                                            favorites: showFavorites ? favorites : nil,
                                                            searchText: searchText)
                if !sections.isEmpty {
                    ScrollViewReader { scrollViewReaderProxy in
                        ScrollView {
                            RefreshControlView(coordinateSpace: .named("RefreshControlView")) {
                                bridgeStore.refreshBridgeModels()
                            }
                            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                ForEach(sections) { bridgesSection in
                                    Section {
                                        ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                            NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, favorites: favorites)) {
                                                BridgeListRow(bridgeModel: bridgeModel)
                                                    .padding([.leading, .trailing])
                                            }
                                            Divider()
                                        }
                                        .id(topID)
                                    } header: {
                                        HStack {
                                            sectionLabel(bridgesSection.sectionName, bridgeInfoGrouping)
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
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        let msg = showFavorites ? "No Favorites Found" : ""
                        Text(msg)
                        Spacer()
                    }
                }
            }
            .background(Color.pbBgnd)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func pageTitleText(_ bridgeInfoGrouping: BridgeSearcher.BridgeInfoGrouping) -> String {
        var title = "Pittsburgh City Bridges by"
        switch bridgeInfoGrouping {
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
    private func sectionLabel(_ sectionName: String, _ sectionListby: BridgeSearcher.BridgeInfoGrouping) -> some View {
        switch sectionListby {
        case .neighborhood:
            Text("\(sectionName) \(AppTextCopy.SortedBySection.neighborhood)")
        case .name:
            Text("\(sectionName) \(AppTextCopy.SortedBySection.name)")
        case .year:
            Text("\(AppTextCopy.SortedBySection.year) \(sectionName)")
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
