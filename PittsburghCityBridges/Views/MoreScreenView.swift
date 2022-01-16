//
//  MoreScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/3/22.
//

import SwiftUI

struct MoreScreenView: View {
    var body: some View {
        VStack {
            TitleHeader(title: "Pittsburgh City Bridges")
        NavigationView {
            List {
                NavigationLink {
                    CreditsScreenView()
                }
                label: {
                    Label("Credits", systemImage: "megaphone")
                }
                NavigationLink {
                    DirectionsDisclaimerView(disclaimerTextOnly: true, closeTouched: nil)
                }
                label: {
                    Label("Disclaimer", systemImage: "building.columns")
                }
                NavigationLink {
                    OnBoardingScreenView()
                }
                label: {
                    Label("Landing Screens", systemImage: "sum")
                }
                NavigationLink {
                    SettingsScreenView()
                }
                label: {
                    Label("Settings", systemImage: "slider.vertical.3")
                }
            }
        }
        }
    }
}

struct MoreScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreenView()
            .preferredColorScheme(.dark)
    }
}
