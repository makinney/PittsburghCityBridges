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
                                    AppIconCreditsScreen()
                                }
                                label: {
                                    Label("App Icon", systemImage: "megaphone")
                                }
                                .listRowBackground(Color.pbBgnd)
                                NavigationLink {
                                    OpenDataCreditsScreen()
                                }
                                label: {
                                    Label("Western Pennsylvania Regional Data Center Open Data", systemImage: "slider.vertical.3")
                                }
                                .listRowBackground(Color.pbBgnd)
                                NavigationLink {
                                    OnBoardingContentView()
                                }
                            label: {
                                Label("OnBoarding Screens", systemImage: "sum")
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
