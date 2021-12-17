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
    private var sectionListBy: BridgeListViewModel.SectionListBy = .neighborhood
    
    private var bridgeListViewModel: BridgeListViewModel
    
    init(_ bridgeListViewModel: BridgeListViewModel, sectionListBy: BridgeListViewModel.SectionListBy = .name) {
        self.bridgeListViewModel = bridgeListViewModel
        self.sectionListBy = sectionListBy
        //      UITableView.appearance().backgroundColor = .green
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
                        //               .background(Color("SteelersBlack"))
                        .font(.body)
                    }
                    
                    //            .listRowBackground(Color.orange)
                    //           .background(Color.purple)
                    .font(.headline)
                }
            }
            .navigationBarHidden(true)
        }
        //     .foregroundColor(Color.blue)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func makeNavigationTitle(for selectedSection: BridgeListViewModel.SectionListBy) -> String {
        var title = ""
        switch selectedSection {
        case .name:
            title = "by Name"
        case .neighborhood:
            title = "by Location"
        case .year:
            title = "by Year Built"
        }
        return title
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
