//
//  OnBoardingCloseScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/5/22.
//

import SwiftUI

struct OnBoardingCloseScreen: View {
    @Binding var onBoardingComplete: Bool

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(AppTextCopy.onboardingOpenDataSource)
            Text(AppTextCopy.onBoardingCloseScreen)
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
                .padding()
            if !onBoardingComplete {
                HStack {
                    Spacer()
                    Button("Close") {
                        onBoardingComplete  = true
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                            .stroke(Color.pbTextFnd, lineWidth: 2)
                    )
                    Spacer()
                }
            }
            Spacer()
        }
        .font(.body)
        .multilineTextAlignment(.leading)
        .foregroundColor(.pbTextFnd)
    }
}

struct OnBoardingCloseScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingCloseScreen(onBoardingComplete: .constant(false))
    }
}
