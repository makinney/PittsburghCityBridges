//
//  DirectionsDisclaimerAgreement.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/21/22.
//

import SwiftUI

struct DirectionsDisclaimerAgreement: View {
    var body: some View {
        GroupBox(label:
                    Label("Disclaimer", systemImage: "building.columns")
        ) {
            ScrollView(.vertical, showsIndicators: true) {
                HStack {
                    Text(AppTextCopy.directionDisclaimerAgreement)
                        .font(.body)
                }
            }
        }
        .background(Color.creditscreenBgnd)
        .padding()
    }
    
}

struct DirectionsDisclaimerAgreement_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsDisclaimerAgreement()
    }
}
