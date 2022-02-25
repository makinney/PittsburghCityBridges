//
//  MoreScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/3/22.
//

import SwiftUI

struct MoreScreenView: View {
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color.pbTitleTextBgnd)
    }
    var body: some View {
        ZStack {
         //   Color.red
            VStack {
                    TitleHeader(title: "Pittsburgh City Bridges")
                            NavigationView {
                            List {
                                NavigationLink {
                                    AppIconCreditsScreen()
                                }
                                label: {
                                    Label("App Icon Credit", systemImage: "megaphone")
                                }
                                .listRowBackground(Color.pbTitleTextBgnd)
                                NavigationLink {
                                    DirectionsDisclaimerAgreement()
                                }
                                label: {
                                    Label("Directions Disclaimer", systemImage: "building.columns")
                                }
                                .listRowBackground(Color.pbTitleTextBgnd)
                                NavigationLink {
                                    OnBoardingContentView()
                                }
                                label: {
                                    Label("OnBoarding Screens", systemImage: "sum")
                                }
                                .listRowBackground(Color.pbTitleTextBgnd)
                                NavigationLink {
                                    OpenDataCreditsScreen()
                                }
                                label: {
                                    Label("Open Data Credit", systemImage: "slider.vertical.3")
                                }
                                .listRowBackground(Color.pbTitleTextBgnd)
                            }
                            .foregroundColor(Color.pbTitleTextFgnd)
            
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
            .background(Color.pbTitleTextBgnd)
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
