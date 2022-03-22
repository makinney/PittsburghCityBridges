//
//  Refresh.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/23/22.
//  Credit to Prafulla Singh https://prafullkumar77.medium.com/how-to-making-pure-swiftui-pull-to-refresh-b497d3639ee5

import SwiftUI

struct RefreshControlView: View {
    var coordinateSpace: CoordinateSpace
    var onRefresh: ()->Void
    @State var refresh: Bool = false
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: coordinateSpace).midY > 20) {
                Spacer()
                    .onAppear {
                        if refresh == false {
                            onRefresh()
                        }
                        refresh = true
                    }
            } else if (geo.frame(in: coordinateSpace).maxY < 1) {
                Spacer()
                    .onAppear {
                        refresh = false
                    }
            }
            ZStack(alignment: .center) {
                if refresh { ///show loading if refresh called
                    ProgressView()
                        .tint(.accentColor)
                }
            }.frame(width: geo.size.width)
        }.padding(.top, -50)
    }
}

struct PullToRefreshDemo: View {
    var body: some View {
        ScrollView {
            RefreshControlView(coordinateSpace: .named("RefreshControl")) {
                //refresh view here
            }
            Text("Some view...")
        }.coordinateSpace(name: "RefreshControl")
    }
}

struct Refresh_Previews: PreviewProvider {
    static var previews: some View {
        PullToRefreshDemo()
        PullToRefreshDemo()
            .preferredColorScheme(.dark)
    }
}
