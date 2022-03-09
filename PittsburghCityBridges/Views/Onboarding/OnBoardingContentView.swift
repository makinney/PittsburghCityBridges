//
//  OnBoardingScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/16/22.
//

import SwiftUI

struct OnBoardingContentView: View {
 
    var body: some View {
        TabView {
            OnBoardingIntroScreen()
//            OnBoardingBridgePhotosScreen()
//            OnBoardingBrowseScreen()
//            OnBoardingMapScreen()
//            OnBoardingSortAndSearchScreen()
//            OnboardingCollapsedBridgeScreen()
//            OnBoardingCloseScreen()
        }
        .background(Color.pbBgnd)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

struct OnBoardingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingContentView()
    }
}
