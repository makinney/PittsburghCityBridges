//
//  OnboardingCollapsedBridgeScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/5/22.
//

import SwiftUI

struct OnboardingCollapsedBridgeScreen: View {
    let cornerRadius = 10.0
    var body: some View {
        VStack {
            Spacer()
            Text("The Forbes Avenue Frick Park bridge, also called the Fern Hollow bridge, as it was before it collapsed in January 2022. This bridge is in the City of Pittsburgh Bridges OpenData database")
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
                .padding(.vertical)
            Image("frickParkBridge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .cornerRadius(cornerRadius)
                .overlay( RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.pbTextFnd, lineWidth: 2))
            Spacer()
        }
        .padding()
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
