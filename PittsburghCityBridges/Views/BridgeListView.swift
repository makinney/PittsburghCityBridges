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
    @State private var sectionListBy: BridgeListViewModel.SectionListBy = .neighborhood
    
    private var bridgeListViewModel: BridgeListViewModel
    private var fileServices: FileServices
  
    init(_ bridgeListViewModel: BridgeListViewModel) {
        do {
            try fileServices = FileServices()
        } catch {
            fatalError("failed to create file services \(error.localizedDescription)")
        }
        self.bridgeListViewModel = bridgeListViewModel
  //      UITableView.appearance().backgroundColor = .green
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(bridgeListViewModel.sectionList(sectionListBy)) { bridgesSection in
                    Section("\(bridgesSection.sectionName)") {
                        ForEach(bridgesSection.bridgeModels) { bridgeModel in
                            NavigationLink(destination: BridgeDetailsView(fileServices: fileServices,
                                                                          bridgeModel: bridgeModel)) {
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
            .navigationTitle("List of Bridges")
        
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
