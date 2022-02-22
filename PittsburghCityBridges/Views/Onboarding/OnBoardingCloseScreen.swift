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
            Text(AppTextCopy.onBoardingCloseScreen)
                .font(.headline)
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
                            .stroke(Color.secondary, lineWidth: 2)
                    )
                    Spacer()
                }
            }
            Spacer()
        }
        .font(.body)
        .multilineTextAlignment(.leading)
        .foregroundColor(.pbTextFgndYellow)
    }
}

struct OnBoardingCloseScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingCloseScreen(onBoardingComplete: .constant(false))
    }
}