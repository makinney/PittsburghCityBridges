//
//  BridgeListView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct BridgeListView: View {
    @EnvironmentObject var bridgeService: BridgeService

    var body: some View {
        NavigationView {
            List {
                ForEach(bridgeService.bridgeViewModels) { bridgeViewModel in
                    NavigationLink(bridgeViewModel.name, destination: BridgeDetailsView(bridgeViewModel: bridgeViewModel))
                }
            }
        }
    }
}

struct BridgeListView_Previews: PreviewProvider {
    static let bridgeService = BridgeService()
    static var previews: some View {
        BridgeListView()
            .environmentObject(bridgeService) // TODO: canned data
            .onAppear {
                bridgeService.preview()
            }
    }
    
    static func update() {
        bridgeService.preview()
    }
}
