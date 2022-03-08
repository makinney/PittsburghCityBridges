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
        VStack(alignment: .leading) {
            Spacer()
            Text(AppTextCopy.onBoardingCloseScreen)
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
            .padding()
            if !onBoardingComplete {
                HStack {
                    Spacer()
                    Button(AppTextCopy.onBoardingCloseScreenButton) {
                        onBoardingComplete  = true
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                            .stroke(Color.accentColor, lineWidth: 2)
                    )
                    Spacer()
                }
                .padding(.vertical, 20)
            }
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
        OnBoardingCloseScreen(onBoardingComplete: .constant(false))
        OnBoardingCloseScreen(onBoardingComplete: .constant(false))
            .preferredColorScheme(.dark)
    }
}
