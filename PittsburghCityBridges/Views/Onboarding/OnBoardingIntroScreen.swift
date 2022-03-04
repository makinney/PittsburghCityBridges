//
//  OnBoardingDataSourceScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/7/22.
//

import SwiftUI

struct OnBoardingIntroScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(AppTextCopy.onBoardingIntroFirstPart)
            .padding()
            Spacer()
        }
        .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 500)
        .multilineTextAlignment(.leading)
        .foregroundColor(.pbTextFnd)
    }
}

struct OnBoardingDataSourceScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingIntroScreen()
    }
}
