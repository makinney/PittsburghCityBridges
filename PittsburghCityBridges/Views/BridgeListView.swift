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
    @AppStorage("brigeInfoGrouping") private var brigeInfoGrouping = BridgeListViewModel.BridgeInfoGrouping.neighborhood
    private var bridgeListViewModel: BridgeListViewModel
    
    init(_ bridgeListViewModel: BridgeListViewModel, brigeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping) {
        self.bridgeListViewModel = bridgeListViewModel
        self.brigeInfoGrouping = brigeInfoGrouping
    }
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
            menuBar()
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    ForEach(bridgeListViewModel.sections(groupedBy: brigeInfoGrouping)) { bridgesSection in
                        Section {
                            ForEach(bridgesSection.bridgeModels) { bridgeModel in
                                NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel, pbColorPalate: bridgesSection.pbColorPalate)) {
                                    BridgeListRow(bridgeModel: bridgeModel)
                                        .padding([.leading])
                                }
                                Divider()
                            }
                            .font(.body)
                        } header: {
                            HStack {
                                sectionLabel(bridgesSection.sectionName, brigeInfoGrouping)
                                    .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                                    .font(.title3)
                                    .padding([.leading])
                                Spacer()
                            }
                        }
                        .font(.headline)
                        .foregroundColor(bridgesSection.pbColorPalate.textFgnd)
                        .background(bridgesSection.pbColorPalate.textBgnd)
                    }
                    }
            }
        }
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private func sectionLabel(_ sectionName: String, _ sectionListby: BridgeListViewModel.BridgeInfoGrouping) -> some View {
        
        switch sectionListby {
        case .neighborhood:
            Text("\(sectionName) Neighborhood")
        case .name:
            Text("Starting with \(sectionName)")
        case .year:
            Text("Built in \(sectionName)")
        }
    }
    
    private func menuBar() -> some View {
        HStack {
            Spacer()
            Text("Pittsburgh Bridges")
                .foregroundColor(.pbTitleTextFgnd)
                .font(.title)
            Spacer()
            sortMenu()
                .padding(.trailing, 10)
        }
        .background(Color.pbTitleTextBgnd)
    }
    
    private func sortMenu() -> some View {
        Menu(content: {
            Button {
                brigeInfoGrouping = .name
            } label: {
                makeCheckedSortLabel("By Names", selectedSection: .name)
            }
            Button {
                brigeInfoGrouping = .neighborhood
            } label: {
                makeCheckedSortLabel("By Neighborhoods", selectedSection: .neighborhood)
            }
            Button {
                brigeInfoGrouping = .year
            } label: {
                makeCheckedSortLabel("By Year Built", selectedSection: .year)
            }
        }, label: {
            Label("Sort", systemImage: "rectangle.split.3x3")
                .labelStyle(.iconOnly)
        })
    }
    
    private func makeCheckedSortLabel(_ name: String, selectedSection: BridgeListViewModel.BridgeInfoGrouping) -> Label<Text, Image> {
        if self.brigeInfoGrouping == selectedSection {
            return Label(name, systemImage: "checkmark.square.fill")
        } else {
            return Label(name, systemImage: "square")
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
