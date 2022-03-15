//
//  OnBoardingCloseScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/5/22.
//

import SwiftUI

struct OnBoardingDisclaimerScreen: View {

    var body: some View {
        ZStack {
            Color.pbBgnd
            VStack(alignment: .leading) {
                Text(AppTextCopy.onBoardingCloseScreen)
                    .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
                .padding()
                Spacer()
            }
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 700)
            .font(.body)
            .multilineTextAlignment(.leading)
            .background(Color.pbBgnd)
        .foregroundColor(.pbTextFnd)
        }
    }
}

struct OnBoardingCloseScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingDisclaimerScreen()
        OnBoardingDisclaimerScreen()
            .preferredColorScheme(.dark)
    }
}
