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
            Text("The Forbes Avenue Frick Park, also called the Fern Hollow bridge, is, or was?, a city bridge. Here it is before it collapsed in January 2022.")
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
        .foregroundColor(.pbTextFnd)
    }
}

struct OnboardingCollapsedBridgeScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCollapsedBridgeScreen()
    }
}
