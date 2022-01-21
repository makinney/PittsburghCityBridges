//
//  DirectionsDisclaimerAgreement.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/21/22.
//

import SwiftUI

struct DirectionsDisclaimerAgreement: View {
    @AppStorage(StorageKeys.userAgreedDirectionsDisclaimer) private var userAgreedDirectionsDisclaimer = false
    var body: some View {
        GroupBox(label:
                    Label("Disclaimer", systemImage: "building.columns")
        ) {
            ScrollView(.vertical, showsIndicators: true) {
                HStack {
                    Text(PBText.directionDisclaimerAgreement)
                        .font(.body)
                }
            }
  //          .frame(height: 300)
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
