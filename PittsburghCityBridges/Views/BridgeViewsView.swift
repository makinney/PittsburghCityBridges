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
                Text("Pittsburgh City Bridges")
                BridgeListView(bridgeListViewModel)
            }
        case .photos:
            VStack {
                Text("Pittsburgh City Bridges")
                BridgePhotosView(bridgeListViewModel)
            }
        }
    }
}

struct BridgeViewsView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()

    static var previews: some View {
        BridgeViewsView(BridgeListViewModel(bridgeStore))
    }
}
