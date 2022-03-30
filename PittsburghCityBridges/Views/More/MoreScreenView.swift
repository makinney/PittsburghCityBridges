//
//  MoreScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/3/22.
//

import SwiftUI

struct MoreScreenView: View {
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color.pbBgnd)
    }
    var body: some View {
        ZStack {
            //   Color.red
            VStack {
                TitleHeader(title: "Pittsburgh City Bridges")
                NavigationView {
                    List {
                        NavigationLink {
                            OnBoardingIntroScreen()
                        }
                    label: {
                        Label("About", systemImage: "a.square")
                    }
                    .listRowBackground(Color.pbBgnd)
                        NavigationLink {
                            OnBoardingDisclaimerScreen()
                        }
                    label: {
                        Label("Disclaimer", systemImage: "building.columns")
                    }
                    .listRowBackground(Color.pbBgnd)
                        NavigationLink {
                            OnboardingCollapsedBridgeScreen()
                        }
                    label: {
                        Label("Fern Hollow Bridge", systemImage: "bus")
                    }
                    .listRowBackground(Color.pbBgnd)
                        NavigationLink {
                            OpenDataCreditsScreen()
                        }
                    label: {
                        Label("Open Data Source - WPRDC", systemImage: "folder")
                    }
                    .listRowBackground(Color.pbBgnd)
                    }
                    .foregroundColor(Color.pbTextFnd)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .background(Color.pbBgnd)
        }
    }
}

struct MoreScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreenView()
        MoreScreenView()
            .preferredColorScheme(.dark)
    }
}
