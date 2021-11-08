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
    @State private var groupBy: BridgeStore.GroupBy = .name
    var body: some View {
        NavigationView {
            List {
                ForEach(bridgeStore.sort(groupBy: groupBy)) { bridgeGroup in
                    Section("\(bridgeGroup.groupName)") {
                        ForEach(bridgeGroup.bridgeModels) { bridgeModel in
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
                        Text("Bridge Sort By")
                        Button("Name") {
                            self.groupBy = .name
                        }
                        Button("Neighborhood") {
                            self.groupBy = .neighborhood
                        }
                        Button("Year") {
                            self.groupBy = .year
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
        BridgeListView()
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
        BridgeListView()
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
