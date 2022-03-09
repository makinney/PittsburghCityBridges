//
//  OBScreenB.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/27/22.
//

import SwiftUI

struct OnBoardingBridgePhotosScreen: View {
    
    var vehicleBridges = ["onboardingBridgeA", "onboardingBridgeB", "onboardingBridgeC",
                          "onboardingBridgeD", "onboardingBridgeE", "onboardingBridgeF",
                          "onboardingBridgeG", "onboardingBridgeH", "onboardingBridgeK",
                          "onboardingBridgeM", "onboardingBridgeN", "onboardingBridgeP"]
    var bigBridgesColumns: [GridItem] = Array(repeating: .init(.flexible()), count: UIDevice.current.userInterfaceIdiom == .phone ? 3 : 4)
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Some examples of city bridges include vehicle bridges, pedestrian only bridges, even bridges in parks.")
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
                .padding()
                .foregroundColor(.pbTextFnd)
                LazyVGrid(columns: bigBridgesColumns) {
                    ForEach(vehicleBridges, id: \.self) { vehicleBridge in
                        getBridgeImage(vehicleBridge)
                    }
                }
                .padding(.horizontal, 5)
            Spacer()
        }
    }
    
    private func getBridgeImage(_ name: String) -> some View {
        Image(name)
                   .resizable()
                   .aspectRatio(1.0, contentMode: .fit)
                   .clipped()
                   .cornerRadius(PCBImage.cornerRadius)
                   .background (
                       RoundedRectangle(cornerRadius: PCBImage.cornerRadius)
                           .stroke(Color.pbTextFnd, lineWidth: 4)
                   )
    }
}

struct OBScreenB_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingBridgePhotosScreen()
    }
}
