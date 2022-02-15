//
//  OnboardingCollapsedBridgeScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/5/22.
//

import SwiftUI

struct OnboardingCollapsedBridgeScreen: View {
    let cornerRadius = 20.0
    var body: some View {
        VStack {
            Text("The City of Pittsburgh Forbes Avenue Frick Park bridge also called the Fern Hollow bridge before it collapsed in January 2022.")
                .padding(.vertical)
            Image("frickParkBridge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .cornerRadius(cornerRadius)
                .overlay( RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.pbTextFgndYellow, lineWidth: 2))
        }
        .padding()
        .foregroundColor(.pbTextFgndYellow)
    }
}

struct OnboardingCollapsedBridgeScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCollapsedBridgeScreen()
    }
}
