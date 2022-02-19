//
//  MoreScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/3/22.
//

import SwiftUI

struct MoreScreenView: View {
    var body: some View {
        VStack(spacing: 0) {
            TitleHeader(title: "Pittsburgh City Bridges")
        NavigationView {
            List {
                NavigationLink {
                    AppIconCreditsScreen()
                }
                label: {
                    Label("App Icon Credit", systemImage: "megaphone")
                }
                NavigationLink {
                    DirectionsDisclaimerAgreement()
                }
                label: {
                    Label("Directions Disclaimer", systemImage: "building.columns")
                }
                NavigationLink {
                    OnBoardingContentView()
                }
                label: {
                    Label("OnBoarding Screens", systemImage: "sum")
                }
                NavigationLink {
                    OpenDataCreditsScreen()
                }
                label: {
                    Label("Open Data Credit", systemImage: "slider.vertical.3")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct MoreScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreenView()
            .preferredColorScheme(.dark)
    }
}
