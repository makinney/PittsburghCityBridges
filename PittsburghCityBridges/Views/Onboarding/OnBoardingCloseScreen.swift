//
//  OnBoardingCloseScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/5/22.
//

import SwiftUI

struct OnBoardingCloseScreen: View {

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(AppTextCopy.onBoardingCloseScreen)
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
            .padding()
            Spacer()
        }
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 700)
        .font(.body)
        .multilineTextAlignment(.leading)
        .foregroundColor(.pbTextFnd)
    }
}

struct OnBoardingCloseScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingCloseScreen()
        OnBoardingCloseScreen()
            .preferredColorScheme(.dark)
    }
}
