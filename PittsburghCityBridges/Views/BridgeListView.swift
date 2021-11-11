//
//  BridgeListView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct BridgeListView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @SceneStorage("BridgeListView.selectedBridge") private var selectedBridgeID: Int?
    @State private var sectionListBy: BridgeListViewModel.SectionListBy = .neighborhood
    
    private var bridgeListViewModel: BridgeListViewModel
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(bridgeListViewModel.sectionList(sectionListBy)) { bridgesSection in
                    Section("\(bridgesSection.sectionName)") {
                        ForEach(bridgesSection.bridgeModels) { bridgeModel in
                            NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, selectedBridgeID: $selectedBridgeID),
                                           tag: bridgeModel.id,
                                           selection: $selectedBridgeID) {
                                BridgeListRow(bridgeModel: bridgeModel)
                            }
                        }
                        .font(.body)
                    }
                    .font(.headline)
                }
            }
            .navigationTitle("City Bridges")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button("Name") {
                            self.sectionListBy = .name
                        }
                        Button("Neighborhood") {
                            self.sectionListBy = .neighborhood
                        }
                        Button("Year") {
                            self.sectionListBy = .year
                        }
                    },
                         label: {
                        Text("Sort")
                    })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onContinueUserActivity(BridgeDetailsView.bridgeDetailsUserActivityType) { userActivity in
            if let bridgeDetailViewID = try? userActivity.typedPayload(BridgeDetailsViewID.self) {
                selectedBridgeID = bridgeDetailViewID.id
            }
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
