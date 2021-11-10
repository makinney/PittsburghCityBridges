//
//  BridgeListView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct BridgeListView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @State private var showSheet = false
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
                            NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
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
