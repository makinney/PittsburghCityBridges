//
//  BridgePhotosListView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/7/22.
//

import SwiftUI
import os

struct BridgesPhotosListView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @EnvironmentObject var favorites: Favorites
    @AppStorage("bridgesPhotoListView.searchCategory") private var searchCategory = BridgeSearcher.SearchCategory.neighborhood
    @AppStorage("bridgesPhotoListView.showFavorites") private var showFavorites = false
    @Namespace private var topID
    @State private var searchText = ""
    private var bridgeSearcher: BridgeSearcher
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgesPhotosListView")
    
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
                let bridgeModelCategories = bridgeSearcher.search(searchCategory: searchCategory,
                                                       searchText: searchText,
                                                       favorites: showFavorites ? favorites : nil)
                if !bridgeModelCategories.isEmpty {
                    ScrollViewReader { scrollViewReaderProxy in
                        ScrollView {
                            RefreshControlView(coordinateSpace: .named("RefreshControlView")) {
                                bridgeStore.refreshBridgeModels()
                            }
                            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                ForEach(bridgeModelCategories) { bridgesSection in
                                    Section {
                                        ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                            NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, favorites: favorites)) {
                                                if let imageURL = bridgeModel.imageURL {
                                                    SinglePhotoView(imageURL: imageURL, bridgeModel: bridgeModel)
                                                }
                                            }
                                            Divider()
                                        }
                                        .padding([.bottom])
                                        .id(topID)
                                    } header: {
                                        HStack {
                                            sectionLabel(bridgesSection.sectionName, searchCategory)
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
            .navigationBarHidden(true)
            .background(Color.pbBgnd)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func pageTitleText(_ searchCategory: BridgeSearcher.SearchCategory) -> String {
        var title = "Bridge Photos by"
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
    private func sectionLabel(_ sectionName: String, _ sectionListby: BridgeSearcher.SearchCategory) -> some View {
        switch sectionListby {
        case .neighborhood:
            Text("\(sectionName) \(AppTextCopy.SortedBySection.neighborhood) ")
        case .name:
            Text("\(sectionName) \(AppTextCopy.SortedBySection.name) ")
        case .year:
            Text("\(AppTextCopy.SortedBySection.year) \(sectionName)")
        }
    }
}

struct BridgePhotosListView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static let favorites = Favorites()
    
    static var previews: some View {
        BridgesPhotosListView(BridgeSearcher(bridgeStore))
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
        BridgesPhotosListView(BridgeSearcher(bridgeStore))
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
