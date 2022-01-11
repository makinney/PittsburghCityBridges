//
//  DisclaimerView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/10/22.
//

import SwiftUI

struct DirectionsDisclaimerView: View {
    @AppStorage(StorageKeys.userAgreedDirectionsDisclaimer) private var userAgreedDirectionsDisclaimer = false
    @Environment(\.presentationMode) var presentationMode
    var closeTouched: (() -> Void)?
    
    var body: some View {
        GroupBox(label:
                    Label("Disclaimer", systemImage: "building.columns")
        ) {
            ScrollView(.vertical, showsIndicators: true) {
                Text(PBText.directionDisclaimerAgreement)
                    .font(.footnote)
            }
            .frame(height: 200)
            Toggle(isOn: $userAgreedDirectionsDisclaimer) {
                Text("I agree to the above terms")
            }
            .padding()
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
                self.closeTouched?()
            }
            .padding([.leading, .trailing])
            .background(Color.white.cornerRadius(5))
        }
        .shadow(radius: 10)
    }
}

struct DisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsDisclaimerView()
            .preferredColorScheme(.dark)
        DirectionsDisclaimerView()
            .preferredColorScheme(.light)
    }
}
