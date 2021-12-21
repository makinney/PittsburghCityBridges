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
            ScrollView {
                LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders]) {
                    ForEach(bridgeListViewModel.sectionList(sectionListBy)) { bridgesSection in
                        Section {
                            ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
                                    BridgeListRow(bridgeModel: bridgeModel)
                                        .padding([.trailing, .leading], 10)
                                        .padding([.top], 10)
                                }
                            }
                            //               .background(Color("SteelersBlack"))
                            .font(.body)
                        } header: {
                            HStack {
                                Spacer()
                                Text("\(bridgesSection.sectionName)")
                                    .foregroundColor(Color("SteelersGold"))
                                Spacer()
                            }
                                .background(Color("SteelersBlack"))
     //                       .background(Color.white)
//                            .background(Color.black)
                        }
                        
                        //            .listRowBackground(Color.orange)
                        //           .background(Color.orange)
                        .font(.headline)
                    }
                    
                }
                //       .listStyle(.grouped)
            }
            
            .navigationBarHidden(true)
        }
        //     .foregroundColor(Color.blue)
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
