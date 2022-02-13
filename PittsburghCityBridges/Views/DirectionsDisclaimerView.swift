//
//  DisclaimerView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/10/22.
//

import SwiftUI

struct DirectionsDisclaimerView: View {
    @State private var userAgreedDirectionsDisclaimer = false
    @Environment(\.presentationMode) var presentationMode
    var userAcceptedDisclaimer: ((Bool) -> Void)?
    
    init(userAcceptedDisclaimer: ((Bool) -> Void)? = nil) {
        self.userAcceptedDisclaimer = userAcceptedDisclaimer
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Pittsburgh City Bridges")
                .font(.title3)
                .foregroundColor(.pbTitleTextFgnd)
                .padding()
            GroupBox(label:
                        Label("Disclaimer", systemImage: "building.columns")
            ) {
                ScrollView(.vertical, showsIndicators: true) {
                    HStack {
                        Text(AppTextCopy.directionDisclaimerAgreement)
                            .font(.body)
                    }
                    HStack {
                        Toggle(isOn: $userAgreedDirectionsDisclaimer) {
                            Text("I agree to the above terms")
                        }
                    }
                }
                .frame(height: 400)
                .padding()
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                    self.userAcceptedDisclaimer?(userAgreedDirectionsDisclaimer)
                }
                .padding([.leading, .trailing])
                .background(Color.white.cornerRadius(5))
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 400)
            .shadow(radius: 10)
        }
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
