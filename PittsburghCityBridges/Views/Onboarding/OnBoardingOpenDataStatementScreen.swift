//
//  OBScreenA.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/27/22.
//

import SwiftUI

struct OnBoardingOpenDataStatementScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Text(AppTextCopy.onboardingOpenDataSource)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()
                .foregroundColor(.pbTextFgndYellow)
            Spacer()
        }
    }
}

struct OBScreenA_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingOpenDataStatementScreen()
        OnBoardingOpenDataStatementScreen()
            .preferredColorScheme(.dark)
    }
}
