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
    @AppStorage("bridgesPhotoListView.bridgeInfoGrouping") private var bridgeInfoGrouping = BridgeListViewModel.BridgeInfoGrouping.neighborhood
    @AppStorage("bridgesPhotoListView.showFavorites") private var showFavorites = false
    @Namespace private var topID
    @State private var searchText = ""
    private var bridgeListViewModel: BridgeListViewModel
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgesPhotosListView")
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TitleHeader(title: pageTitleText(bridgeInfoGrouping))
                HeaderToolBar(bridgeInfoGrouping: $bridgeInfoGrouping, showFavorites: $showFavorites)
                SearchFieldView(searchText: $searchText, prompt: searchPrompt(bridgeInfoGrouping))
                    .padding(.leading)
                let sections = bridgeListViewModel.sections(groupedBy: bridgeInfoGrouping,
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
                                            sectionLabel(bridgesSection.sectionName, bridgeInfoGrouping)
                                                .foregroundColor(Color.pbTitleTextFgnd)
                                                .font(.body)
                                                .padding([.leading])
                                                .padding([.top], 10)
                                                .padding([.bottom], 5)
                                            Spacer()
                                        }
                                    }
                                    .foregroundColor(Color.pbTitleTextFgnd)
                                    .background(Color.pbTitleTextBgnd)
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
            .background(Color.pbTitleTextFgnd)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func pageTitleText(_ bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping) -> String {
        var title = "Photos by"
        switch bridgeInfoGrouping {
        case .name:
            title += " Name"
        case .neighborhood:
            title += " Neighborhood"
        case .year:
            title += " Year Bridge Built"
        }
        return title
    }
    
    private func searchPrompt(_ bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping) -> String {
        var prompt = "Search by"
        switch bridgeInfoGrouping {
        case .name:
            prompt += " Name"
        case .neighborhood:
            prompt += " Neighborhood"
        case .year:
            prompt += " Year Built"
        }
        return prompt
    }
    
    @ViewBuilder
    private func sectionLabel(_ sectionName: String, _ sectionListby: BridgeListViewModel.BridgeInfoGrouping) -> some View {
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
        BridgesPhotosListView(BridgeListViewModel(bridgeStore))
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
        BridgesPhotosListView(BridgeListViewModel(bridgeStore))
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
