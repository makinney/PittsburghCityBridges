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
    @State private var viewBridgeAs = ViewBridgeAs.photos
    @State private var sectionListBy: BridgeListViewModel.SectionListBy = .neighborhood
    
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
                    BridgeListView(bridgeListViewModel, sectionListBy: sectionListBy)
                }
            case .photos:
                VStack {
                    menuBar()
                    BridgePhotosView(bridgeListViewModel, sectionListBy: sectionListBy)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: viewBridgeAs)
    }
    
    private func menuBar() -> some View {
        HStack {
            viewSelectMenu()
                .padding(.leading, 10)
            Spacer()
            switch sectionListBy {
            case .neighborhood:
                Text("City Bridges by Neighborhood")
            case .name:
                Text("City Bridges by Name")
            case .year:
                Text("City Bridges by Year Built")
            }
            Spacer()
            sortMenu()
                .padding(.trailing, 10)
        }
    }
    
    private func viewSelectMenu() -> some View {
        Menu("View" ,content: {
            Button {
                viewBridgeAs = .list
            } label: {
                makeCheckedViewLabel("View as List", viewBridgeAs: .list)
            }
            Button {
                viewBridgeAs = .photos
            } label: {
                makeCheckedViewLabel("View as Photos", viewBridgeAs: .photos)
            }
        })
    }
    
    private func sortMenu() -> some View {
        Menu("Sort", content: {
            Button {
                sectionListBy = .neighborhood
            } label: {
                makeCheckedSortLabel("Sort by Neighborhood", selectedSection: .neighborhood)
            }
            Button {
                sectionListBy = .name
            } label: {
                makeCheckedSortLabel("Sort by Name", selectedSection: .name)
            }
            Button {
                sectionListBy = .year
            } label: {
                makeCheckedSortLabel("Sort by Year Built", selectedSection: .year)
            }
        })
    }
    
    private func makeCheckedSortLabel(_ name: String, selectedSection: BridgeListViewModel.SectionListBy) -> Label<Text, Image> {
        if self.sectionListBy == selectedSection {
            return Label(name, systemImage: "checkmark")
        } else {
            return Label(name, systemImage: "")
        }
    }
    
    private func makeCheckedViewLabel(_ name: String, viewBridgeAs: ViewBridgeAs) -> Label<Text, Image> {
        if self.viewBridgeAs == viewBridgeAs {
            return Label(name, systemImage: "checkmark")
        } else {
            return Label(name, systemImage: "")
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
