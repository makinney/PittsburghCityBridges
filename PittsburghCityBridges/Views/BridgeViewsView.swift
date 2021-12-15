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
    @State private var sectionListBy: BridgeListViewModel.SectionListBy = .neighborhood
    
    init(_ bridgeListViewModel: BridgeListViewModel) {
        self.bridgeListViewModel = bridgeListViewModel
        //      UITableView.appearance().backgroundColor = .green
    }
    
    var body: some View {
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
    
    private func menuBar() -> some View {
        HStack {
            viewMenu()
                .padding(.leading, 10)
            Spacer()
            Text("Pittsburgh City Bridges")
            Spacer()
            sortMenu()
                .padding(.trailing, 10)
        }
    }
    
    private func viewMenu() -> some View {
        Menu("View" ,content: {
            Button("As List") {
                viewBridgeAs = .list
            }
            Button("As Photos") {
                viewBridgeAs = .photos
            }
        })
    }
    
    private func sortMenu() -> some View {
        Menu("Sort", content: {
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
        })
    }
    
    private func makeCheckedLabel(_ name: String, selectedSection: BridgeListViewModel.SectionListBy) -> Label<Text, Image> {
        if self.sectionListBy == selectedSection {
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
