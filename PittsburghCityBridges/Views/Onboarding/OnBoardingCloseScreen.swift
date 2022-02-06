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
        VStack {
            Spacer()
            Text(AppTextCopy.onBoardingCloseScreen)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()
            if !onBoardingComplete {
                Button("Close") {
                    onBoardingComplete  = true
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct OnBoardingCloseScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingCloseScreen(onBoardingComplete: .constant(false))
    }
}
