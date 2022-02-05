//
//  OBScreenB.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/27/22.
//

import SwiftUI

struct OnBoardingIntroScreen: View {
    
    var vehicleBridges = ["landingScreenVehicleBridgeA",
                          "landingScreenVehicleBridgeB"]
    
    var bigBridgesColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    let imageCornerRadius = 4.0
    var body: some View {
        VStack {
            Text(AppTextCopy.onBoardingIntroFirstPart)
                .padding()
            Text("Big Bridges")
            LazyVGrid(columns: bigBridgesColumns) {
                ForEach(vehicleBridges, id: \.self) { vehicleBridge in
                    Image(vehicleBridge)
                               .resizable()
                               .aspectRatio(1.0, contentMode: .fill)
                               .cornerRadius(imageCornerRadius)
                               .overlay(
                                   RoundedRectangle(cornerRadius: imageCornerRadius)
                                    .stroke(Color.pbTextFgndYellow, lineWidth: 2)
                                   )
                }
            }
            .padding(.horizontal)
//            Image("mcArdleViaduct1")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .padding()
//                .frame(width: 250, height: 250)
//                .clipped()
//            Text("Pedestrian Bridge")
//            Image("pedistrianBridgeA")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .padding()
//                .frame(width: 250, height: 250)
//                .clipped()
            Spacer()
        }
    }
}

struct OBScreenB_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingIntroScreen()
    }
}
