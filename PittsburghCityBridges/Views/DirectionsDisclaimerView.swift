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
    var showDirections: ((Bool) -> Void)?
    
    init(showDirections: ((Bool) -> Void)? = nil) {
        self.showDirections = showDirections
    }
    
    var body: some View {
        VStack() {
            Text("Pittsburgh City Bridges")
                .font(.headline)
                .foregroundColor(.pbTextFnd)
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
                            Text("I understand and agree")
                        }
                        .padding()
                    }
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(false)
                    }
                    .frame(width: 200)
                    .padding(.vertical, 10)
                    .background(Color.white.cornerRadius(5))
                    .padding(.vertical, 10)
                    mapButtons()
                        .opacity(userAgreedDirectionsDisclaimer ? 1.0 : 0.70)
                }
            }
        }
        .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 400)
    }
    
    private func mapButtons() -> some View {
        VStack(alignment: .center) {
            Text("Get Directions Using:")
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.apple) {
                Button("Apple Maps") {
                    if userAgreedDirectionsDisclaimer {
                        DirectionsProvider.shared.select(mappingApp: .apple)
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(true)
                    }
                }
                .frame(width: 200)
                .padding(.vertical, 10)
                .background(Color.white.cornerRadius(5))
                .padding(.vertical, 10)
            }
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.google) {
                Button("Google Maps") {
                    if userAgreedDirectionsDisclaimer {
                        DirectionsProvider.shared.select(mappingApp: .google)
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(true)
                    }
                }
                .frame(width: 200)
                .padding(.vertical, 10)
                .background(Color.white.cornerRadius(5))
                .padding(.vertical,10)
            }
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.waze) {
                Button("Waze") {
                    if userAgreedDirectionsDisclaimer {
                        DirectionsProvider.shared.select(mappingApp: .waze)
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(true)
                    }
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
