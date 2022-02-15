//
//  OnBoardingScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/16/22.
//

import SwiftUI

struct OnBoardingContentView: View {
    @AppStorage(StorageKeys.onBoardingComplete) private var onBoardingComplete = false
    @State var done = false
 
    var body: some View {
        TabView {
            OnBoardingDataSourceScreen()
            OnBoardingPhotosVehicleBridgesScreen()
            OnBoardingPhotosPedestrianBridgesScreen()
            OnboardingCollapsedBridgeScreen()
            OnBoardingBrowseScreen()
            OnBoardingCloseScreen(onBoardingComplete: $done)
        }
        .onChange(of: done, perform: { newValue in
            onBoardingComplete = done
        })
        .onAppear(perform: {
            done = onBoardingComplete
        })
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

struct OnBoardingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingContentView()
    }
}
