//
//  OnBoardingDataSourceScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/7/22.
//

import SwiftUI

struct OnBoardingDataSourceScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(AppTextCopy.onboardingOpenDataSource)
            .padding()
            Spacer()
        }
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 500)
        .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
        .multilineTextAlignment(.leading)
        .foregroundColor(.pbTextFnd)
    }
}

struct OnBoardingDataSourceScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingDataSourceScreen()
    }
}
