//
//  OBScreenB.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/27/22.
//

import SwiftUI

struct OnBoardingPhotosVehicleBridgesScreen: View {
    
    var vehicleBridges = ["onboardingBridgeA", "onboardingBridgeB", "onboardingBridgeC"]
    var bigBridgesColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let imageCornerRadius = 4.0
    var body: some View {
        VStack {
            Spacer()
            Text("There are vehicle bridges")
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
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

struct OBScreenB_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPhotosVehicleBridgesScreen()
    }
}
