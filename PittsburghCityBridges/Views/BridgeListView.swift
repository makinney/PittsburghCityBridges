//
//  BridgeListView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//
import UIKit
import SwiftUI

struct BridgeListView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @State private var showSheet = false
    @AppStorage("bridgeListView.bridgeInfoGrouping") private var bridgeInfoGrouping = BridgeListViewModel.BridgeInfoGrouping.neighborhood
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
                BridgeMenuBar(bridgeInfoGrouping: $bridgeInfoGrouping)
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        ForEach(bridgeListViewModel.sections(groupedBy: bridgeInfoGrouping)) { bridgesSection in
                            Section {
                                ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                    NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)) {
                                        BridgeListRow(bridgeModel: bridgeModel)
                                            .padding([.leading])
                                    }
                                    Divider()
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
                            }
                            .font(.headline)
                            .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                            .background(bridgesSection.pbColorPalate.textBgnd)
                        }
                    }
                }
            }
            .background(Color.black)
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

struct BridgeListView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        BridgeListView(BridgeListViewModel(bridgeStore))
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
        BridgeListView(BridgeListViewModel(bridgeStore))
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
