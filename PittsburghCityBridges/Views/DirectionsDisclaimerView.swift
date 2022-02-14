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
            GroupBox(label:
                        Label("Directions Disclaimer", systemImage: "building.columns")
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
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        self.userAcceptedDisclaimer?(false)
                    }
                    .frame(width: 200)
                    .padding(.vertical, 10)
                    .background(Color.white.cornerRadius(5))
                    .padding(.vertical, 10)
                    if userAgreedDirectionsDisclaimer {
                        mapButtons()
                    }
                }
            }
        }
        .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 400)
    }
    
    private func mapButtons() -> some View {
        VStack(alignment: .center) {
            Text("Get Directions Using:")
                .padding(.vertical)
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.apple) {
                Button("Apple Maps") {
                    DirectionsProvider.shared.select(mappingApp: .apple)
                    presentationMode.wrappedValue.dismiss()
                    self.userAcceptedDisclaimer?(userAgreedDirectionsDisclaimer)
                }
                .frame(width: 200)
                .padding(.vertical, 10)
                .background(Color.white.cornerRadius(5))
                .padding(.vertical, 10)
            }
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.google) {
                Button("Google Maps") {
                    DirectionsProvider.shared.select(mappingApp: .google)
                    presentationMode.wrappedValue.dismiss()
                    self.userAcceptedDisclaimer?(userAgreedDirectionsDisclaimer)
                }
                .frame(width: 200)
                .padding(.vertical, 10)
                .background(Color.white.cornerRadius(5))
                .padding(.vertical,10)
            }
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.waze) {
                Button("Waze") {
                    DirectionsProvider.shared.select(mappingApp: .waze)
                    presentationMode.wrappedValue.dismiss()
                    self.userAcceptedDisclaimer?(userAgreedDirectionsDisclaimer)
                }
                .frame(width: 200)
                .padding(.vertical, 10)
                .background(Color.white.cornerRadius(5))
                .padding(.vertical, 10)
            }
        }
    }
}

struct DisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsDisclaimerView()
            .preferredColorScheme(.dark)
        //     DirectionsDisclaimerView()
        //       .preferredColorScheme(.light)
    }
}
