//
//  OnBoardingPhotosParkBridgesScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/15/22.
//

import SwiftUI

struct OnBoardingPhotosParkBridgesScreen: View {
    var parkBridges = ["onboardingBridgeG", "onboardingBridgeH", "onboardingBridgeK"]
    var bigBridgesColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let imageCornerRadius = 4.0
    var body: some View {
        VStack {
            Spacer()
            Text("There are park bridges")
                .padding()
                .foregroundColor(.pbTextFgndYellow)
                LazyVGrid(columns: bigBridgesColumns) {
                    ForEach(parkBridges, id: \.self) { parkBridge in
                        Image(parkBridge)
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

struct OnBoardingPhotosParkBridgesScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPhotosParkBridgesScreen()
    }
}
