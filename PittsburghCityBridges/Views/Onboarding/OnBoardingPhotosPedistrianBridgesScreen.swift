//
//  OnBoardingPhotosPedistrianBridgesScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/15/22.
//

import SwiftUI

struct OnBoardingPhotosPedestrianBridgesScreen: View {
    var vehicleBridges = ["onboardingBridgeD", "onboardingBridgeE", "onboardingBridgeF"]
    var bigBridgesColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let imageCornerRadius = 4.0
    var body: some View {
        VStack {
            Spacer()
            Text("There are Pedestrian Bridges")
                .padding()
                .foregroundColor(.pbTextFgndYellow)
                LazyVGrid(columns: bigBridgesColumns) {
                    ForEach(vehicleBridges, id: \.self) { vehicleBridge in
                        Image(vehicleBridge)
                                   .resizable()
                                   .aspectRatio(1.0, contentMode: .fit)
                                   .clipped()
                                   .cornerRadius(imageCornerRadius)
                                   .overlay(
                                       RoundedRectangle(cornerRadius: imageCornerRadius)
                                        .stroke(Color.pbTextFgndYellow, lineWidth: 2)
                                       )
                    }
                }
                .padding(.horizontal)
            Spacer()
        }
    }
}

struct OnBoardingPhotosPedistrianBridgesScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPhotosPedestrianBridgesScreen()
    }
}
