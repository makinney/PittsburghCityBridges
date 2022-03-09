//
//  OnboardingCollapsedBridgeScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/5/22.
//

import SwiftUI

struct OnboardingCollapsedBridgeScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Text(AppTextCopy.onBoardingCollapsedBridge)
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
                .padding(.vertical)
            Image("frickParkBridge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .cornerRadius(PCBImage.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBImage.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 4)
                )
            Spacer()
        }
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 700)
        .background(Color.pbBgnd)
        .foregroundColor(.pbTextFnd)
    }
}

struct OnboardingCollapsedBridgeScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCollapsedBridgeScreen()
        OnboardingCollapsedBridgeScreen()
            .preferredColorScheme(.dark)
    }
}
