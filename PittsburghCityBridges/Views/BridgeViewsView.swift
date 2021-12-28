//
//  BridgeViewsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/15/21.
//

import SwiftUI

enum ViewBridgeAs: Int {
    case list
    case photos
}
struct BridgeViewsView: View {
    private var bridgeListViewModel: BridgeListViewModel
    @AppStorage("viewBridgeAs") private var viewBridgeAs = ViewBridgeAs.list
    @AppStorage("sectionListBy") private var sectionListBy = BridgeListViewModel.SectionListBy.neighborhood
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
        //      UITableView.appearance().backgroundColor = .green
    }
    
    var body: some View {
        VStack {
            switch viewBridgeAs {
            case .list:
                VStack {
                    menuBar()
        //            sortedAs()
                    BridgeListView(bridgeListViewModel, sectionListBy: sectionListBy)
                }
            case .photos:
                VStack {
                    menuBar()
           //         sortedAs()
                    BridgePhotosView(bridgeListViewModel, sectionListBy: sectionListBy)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: viewBridgeAs)
    }
    
    private func menuBar() -> some View {
        HStack {
            viewModeButton()
                .padding(.leading, 10)
            Spacer()
            Text("Pittsburgh Bridges")
                .foregroundColor(.titleTextFgnd)
                .font(.title)
            Spacer()
            sortMenu()
                .padding(.trailing, 10)
        }
        .background(Color.titleTextBkgnd)
    }
    
    private func sortedAs() -> some View {
        HStack {
            Spacer()
            switch sectionListBy {
            case .neighborhood:
                Text("by Neighborhood")
                    .font(.headline)
            case .name:
                Text("by Names")
                    .font(.headline)
            case .year:
                Text("by Year Built")
                    .font(.headline)
            }
            Spacer()
        }
    }
    
    private func viewModeButton() -> some View {
        Button {
            if viewBridgeAs == .list {
                viewBridgeAs = .photos
            } else {
                viewBridgeAs = .list
            }
        } label: {
            Label("Views", systemImage: (viewBridgeAs == .list) ?  "photo.fill.on.rectangle.fill" : "list.dash")
                .labelStyle(.iconOnly)
        }

    }
    
    private func sortMenu() -> some View {
        Menu(content: {
            Button {
                sectionListBy = .name
            } label: {
                makeCheckedSortLabel("By Names", selectedSection: .name)
            }
            Button {
                sectionListBy = .neighborhood
            } label: {
                makeCheckedSortLabel("By Neighborhoods", selectedSection: .neighborhood)
            }
            Button {
                sectionListBy = .year
            } label: {
                makeCheckedSortLabel("By Year Built", selectedSection: .year)
            }
        }, label: {
            Label("Sort", systemImage: "rectangle.split.3x3")
                .labelStyle(.iconOnly)
        })
    }
    
    private func makeCheckedSortLabel(_ name: String, selectedSection: BridgeListViewModel.SectionListBy) -> Label<Text, Image> {
        if self.sectionListBy == selectedSection {
            return Label(name, systemImage: "checkmark.square.fill")
        } else {
            return Label(name, systemImage: "square")
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
