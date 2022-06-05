//
//  OnBoardingContentView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 5/23/22.
//

import SwiftUI

struct OnBoardingContentView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    var body: some View {
        TabView {
            OnBoardingIntroScreen()
            OnboardingCollapsedBridgeScreen()
//            ContentView()
//                .environmentObject(bridgeStore)
        }
        .background(Color.pbBgnd)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

struct OnBoardingContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingContentView()
    }
}
