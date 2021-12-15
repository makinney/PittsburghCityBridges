//
//  BridgeViewsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/15/21.
//

import SwiftUI

enum ViewBridgeAs {
    case list
    case photos
}
struct BridgeViewsView: View {
    private var bridgeListViewModel: BridgeListViewModel
    @State private var viewBridgeAs = ViewBridgeAs.list
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
        //      UITableView.appearance().backgroundColor = .green
    }
    
    var body: some View {
        switch viewBridgeAs {
        case .list:
            VStack {
                menu()
                BridgeListView(bridgeListViewModel)
            }
        case .photos:
            VStack {
                menu()
                BridgePhotosView(bridgeListViewModel)
            }
        }
    }
    
    private func menu() -> some View {
        HStack {
            ZStack {
                HStack {
                    Spacer()
                    Text("Pittsburgh City Bridges")
                    Spacer()
                }
                HStack {
                    Menu("View" ,content: {
                        Button("As List") {
                            viewBridgeAs = .list
                        }
                        Button("As Photos") {
                            viewBridgeAs = .photos
                        }
                    })
                    .padding(.leading, 10)
                    Spacer()
                }
            }
        }
    }
}

struct BridgeViewsView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        BridgeViewsView(BridgeListViewModel(bridgeStore))
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
