//
//  BridgeMenuBar.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/30/21.
//

import SwiftUI

struct HeaderToolBar: View {
    
    @Binding var bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping
    @Binding var showFavorites: Bool
    var pbColorPalate = PBColorPalate()

    var body: some View {
        HStack {
            sortMenu()
                .padding([.leading])
                .padding([.vertical], 5)
            Spacer()
        }
        .background(pbColorPalate.titleTextBgnd)
    }
    
    private func sortMenu() -> some View {
        Menu(content: {
            Button {
                bridgeInfoGrouping = .name
            } label: {
                makeCheckedSortLabel("Group by Names", selectedSection: .name)
            }
            Button {
                bridgeInfoGrouping = .neighborhood
            } label: {
                makeCheckedSortLabel("Group by Neighborhoods", selectedSection: .neighborhood)
            }
            Button {
                bridgeInfoGrouping = .year
            } label: {
                makeCheckedSortLabel("Group by Year Built", selectedSection: .year)
            }
            Button {
                showFavorites.toggle()
            } label: {
                makeFavoriteLabel("Favorites", showFavorites: showFavorites)
            }
        }, label: {
            Label("Sort", systemImage: "slider.vertical.3")
                .labelStyle(.iconOnly)
                .font(.title2)
        })
    }
    
    private func makeCheckedSortLabel(_ name: String, selectedSection: BridgeListViewModel.BridgeInfoGrouping) -> Label<Text, Image> {
        if self.bridgeInfoGrouping == selectedSection {
            return Label(name, systemImage: "checkmark.square.fill")
        } else {
            return Label(name, systemImage: "square")
        }
    }
    
    private func makeFavoriteLabel(_ name: String, showFavorites: Bool) -> Label<Text, Image> {
        if showFavorites {
            return Label(name, systemImage: "checkmark.square.fill")
        } else {
            return Label(name, systemImage: "square")
        }
    }
    
}

struct BridgeMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        HeaderToolBar(bridgeInfoGrouping: .constant(.neighborhood), showFavorites: .constant(false))
    }
}
