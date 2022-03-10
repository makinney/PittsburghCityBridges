//
//  BridgeMenuBar.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/30/21.
//

import SwiftUI

struct HeaderToolBar: View {
    
    @Binding var bridgeInfoGrouping: BridgeSearcher.SearchCategory
    @Binding var showFavorites: Bool
    @Binding var searchText: String

    var body: some View {
        HStack {
            sortMenu()
                .padding([.leading])
            SearchFieldView(searchText: $searchText, bridgeInfoGrouping: bridgeInfoGrouping)
            Text(showFavorites ? "Favorites" : "")
                .foregroundColor(Color.pbTextFnd)
                .padding([.trailing])
                .animation(.easeInOut, value: showFavorites)
        }
        .background(Color.pbBgnd)
    }
    
    private func sortMenu() -> some View {
        Menu(content: {
            Button {
                bridgeInfoGrouping = .name
            } label: {
                makeCheckedSortLabel("Sort by Names", selectedSection: .name)
            }
            Button {
                bridgeInfoGrouping = .neighborhood
            } label: {
                makeCheckedSortLabel("Sort by Neighborhoods", selectedSection: .neighborhood)
            }
            Button {
                bridgeInfoGrouping = .year
            } label: {
                makeCheckedSortLabel("Sort by Year Built", selectedSection: .year)
            }
            Button {
                showFavorites.toggle()
            } label: {
                makeFavoriteLabel("Favorites Only", showFavorites: showFavorites)
            }
        }, label: {
            Label("Sort", systemImage: "slider.vertical.3")
                .labelStyle(.iconOnly)
                .font(.title)
        })
    }
    
    private func makeCheckedSortLabel(_ name: String, selectedSection: BridgeSearcher.SearchCategory) -> Label<Text, Image> {
        if self.bridgeInfoGrouping == selectedSection {
            return Label(name, systemImage: "checkmark.square.fill")
        } else {
            return Label(name, systemImage: "square")
        }
    }
    
    private func makeFavoriteLabel(_ name: String, showFavorites: Bool) -> Label<Text, Image> {
        if showFavorites {
            return Label(name, systemImage: "star.fill")
        } else {
            return Label(name, systemImage: "star")
        }
    }
}

struct BridgeMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        HeaderToolBar(bridgeInfoGrouping: .constant(.neighborhood), showFavorites: .constant(false), searchText: .constant("Search Neighborhood"))
    }
}
