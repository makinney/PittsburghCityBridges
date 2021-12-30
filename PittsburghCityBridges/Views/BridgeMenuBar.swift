//
//  BridgeMenuBar.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/30/21.
//

import SwiftUI

struct BridgeMenuBar: View {
    
    @Binding var bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping
    var pbColorPalate = PBColorPalate()
    
    var body: some View {
        HStack {
            Spacer()
            Text("Pittsburgh Bridges")
                .foregroundColor(pbColorPalate.titleTextFgnd)
                .font(.title)
            Spacer()
            sortMenu()
                .padding(.trailing, 10)
        }
        .background(pbColorPalate.titleTextBgnd)
    }
    
    private func sortMenu() -> some View {
        Menu(content: {
            Button {
                bridgeInfoGrouping = .name
            } label: {
                makeCheckedSortLabel("By Names", selectedSection: .name)
            }
            Button {
                bridgeInfoGrouping = .neighborhood
            } label: {
                makeCheckedSortLabel("By Neighborhoods", selectedSection: .neighborhood)
            }
            Button {
                bridgeInfoGrouping = .year
            } label: {
                makeCheckedSortLabel("By Year Built", selectedSection: .year)
            }
        }, label: {
            Label("Sort", systemImage: "arrow.up.arrow.down.square")
                .labelStyle(.titleAndIcon)
        })
    }
    
    private func makeCheckedSortLabel(_ name: String, selectedSection: BridgeListViewModel.BridgeInfoGrouping) -> Label<Text, Image> {
        if self.bridgeInfoGrouping == selectedSection {
            return Label(name, systemImage: "checkmark.square.fill")
        } else {
            return Label(name, systemImage: "square")
        }
    }
    
}

struct BridgeMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        BridgeMenuBar(bridgeInfoGrouping: .constant(.neighborhood), pbColorPalate: PBColorPalate())
    }
}
