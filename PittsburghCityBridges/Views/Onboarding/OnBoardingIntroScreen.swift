//
//  OBScreenB.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/27/22.
//

import SwiftUI

struct OnBoardingIntroScreen: View {
    
    var vehicleBridges = ["onboardingBridgeA", "onboardingBridgeB", "onboardingBridgeC",
                          "onboardingBridgeD", "onboardingBridgeE", "onboardingBridgeF",
                          "onboardingBridgeG", "onboardingBridgeH", "onboardingBridgeK",
                          "onboardingBridgeL", "onboardingBridgeM", "onboardingBridgeN"]
    
    var bigBridgesColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let imageCornerRadius = 4.0
    var body: some View {
        VStack {
            Spacer()
            Text(AppTextCopy.onBoardingIntroFirstPart)
                .padding()
                .foregroundColor(.pbTextFgndYellow)
            ScrollView {
                LazyVGrid(columns: bigBridgesColumns) {
                    ForEach(vehicleBridges, id: \.self) { vehicleBridge in
                        Image(vehicleBridge)
                                   .resizable()
                                   .aspectRatio(1.0, contentMode: .fit)
                                   .cornerRadius(imageCornerRadius)
                                   .overlay(
                                       RoundedRectangle(cornerRadius: imageCornerRadius)
                                        .stroke(Color.pbTextFgndYellow, lineWidth: 2)
                                       )
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
        }
    }
}

struct OBScreenB_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingIntroScreen()
    }
}
