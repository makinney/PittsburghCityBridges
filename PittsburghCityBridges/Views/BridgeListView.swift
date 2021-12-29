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
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    ForEach(bridgeListViewModel.sectionList(sectionListBy)) { bridgesSection in
                        Section {
                            ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)) {
                                    BridgeListRow(bridgeModel: bridgeModel)
                                        .padding([.leading])
                               //         .padding()
                                    //    .padding([.trailing, .leading], 10)
                                    //    .padding([.top], 10)
                                }
                                Divider()
                            }
                            .font(.body)
                        } header: {
                            HStack {
                                sectionLabel(bridgesSection.sectionName, sectionListBy)
                                    .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                                    .font(.title3)
                                    .padding([.leading])
                                Spacer()
                            }
                        }
                 //       .padding([.top], 5)
                        .font(.headline)
                        .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                        .background(bridgesSection.pbColorPalate.textBgnd)
                    }
           //         .padding([.bottom], 20)
                    
                }
                //       .listStyle(.grouped)
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
        //     .foregroundColor(Color.blue)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private func sectionLabel(_ sectionName: String, _ sectionListby: BridgeListViewModel.SectionListBy) -> some View {
        
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
