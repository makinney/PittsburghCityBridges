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
            Text(AppTextCopy.wprdcDescription)
                .font(.body)
                .italic()
                .padding()
            Spacer()
        }
        .font(.subheadline)
        .multilineTextAlignment(.leading)
        .foregroundColor(.pbTextFgndYellow)
    }
}

struct OnBoardingDataSourceScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingDataSourceScreen()
    }
}
