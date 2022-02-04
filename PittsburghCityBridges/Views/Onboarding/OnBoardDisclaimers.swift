//
//  OBScreenC.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/27/22.
//

import SwiftUI

struct OnBoardDisclaimers: View {
    @Binding var onBoardingComplete: Bool
    var body: some View {
        VStack {
            Spacer()
            Text(PBText.directionDisclaimerAgreement)
                .padding()
            if !onBoardingComplete {
                Button("Close") {
                    onBoardingComplete  = true
                }
            }
            Spacer()
        }
        .onAppear {
            
        }
    }
}

struct OBScreenC_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardDisclaimers(onBoardingComplete: .constant(false))
    }
}
