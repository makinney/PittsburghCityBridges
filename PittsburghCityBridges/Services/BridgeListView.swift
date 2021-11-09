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
    @State private var sectionBy: BridgeListViewModel.SectionSort = .name
    private var bridgeListViewModel: BridgeListViewModel
  
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(bridgeListViewModel.sortBy(sectionBy)) { bridgesSection in
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
                        Text("Sort By")
                        Button("Name") {
                            self.sectionBy = .name
                        }
                        Button("Neighborhood") {
                            self.sectionBy = .neighborhood
                        }
                        Button("Year") {
                            self.sectionBy = .year
                        }
                    },
                         label: {
                        Image(systemName: "ellipsis.circle")
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
