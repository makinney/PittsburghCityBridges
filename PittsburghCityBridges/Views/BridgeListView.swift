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
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
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
            .navigationTitle(makeNavigationTitle(for: sectionListBy))
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button {
                            self.sectionListBy = .neighborhood
                        } label: {
                            makeCheckedLabel("Sort by Location", selectedSection: .neighborhood)
                        }
                        Button {
                            self.sectionListBy = .name
                        } label: {
                            makeCheckedLabel("Sort by Name", selectedSection: .name)
                        }
                        Button {
                            self.sectionListBy = .year
                        } label: {
                            makeCheckedLabel("Sort by Year", selectedSection: .year)
                        }
                    },
                         label: {
                        Label("Sort", systemImage: "arrow.down")
                            .labelStyle(.titleAndIcon)
                    })
                }
            }
        }
        //     .foregroundColor(Color.blue)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func makeCheckedLabel(_ name: String, selectedSection: BridgeListViewModel.SectionListBy) -> Label<Text, Image> {
        if self.sectionListBy == selectedSection {
            return Label(name, systemImage: "checkmark")
        } else {
            return Label(name, systemImage: "")
        }
    }
    
    private func makeNavigationTitle(for selectedSection: BridgeListViewModel.SectionListBy) -> String {
        var title = ""
        switch selectedSection {
        case .name:
            title = "Bridges by Name"
        case .neighborhood:
            title = "Bridges by Location"
        case .year:
            title = "Bridges by Year"
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
