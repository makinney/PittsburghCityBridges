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
        ZStack {
            Color.pbBgnd
            VStack {
                VStack(alignment: .leading) {
                    Label("Directions Disclaimer", systemImage: "building.columns")
                        .padding(.bottom, 5)
                    Text(AppTextCopy.directionDisclaimerAgreement)
                        .font(.body)
                    HStack {
                        Toggle(isOn: $userAgreedDirectionsDisclaimer) {
                            Text(" User assumes all risk of use.")
                                .font(.body)
                        }
                    }
                }
                .padding()
                VStack(alignment: .center) {
                    makButtons()
                        .opacity(userAgreedDirectionsDisclaimer ? 1.0 : 0.50)
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(false)
                    }
                    .frame(width: 150)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                    .cornerRadius(PCBButton.cornerRadius)
                    .background (
                        RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                            .stroke(Color.pbTextFnd, lineWidth: 2)
                    )
                }
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 400)
            .foregroundColor(.pbTextFnd)
        }
    }
    
    private func makButtons() -> some View {
        VStack(alignment: .center) {
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.apple) {
                Button("Apple Maps") {
                    if userAgreedDirectionsDisclaimer {
                        DirectionsProvider.shared.select(mappingApp: .apple)
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(true)
                    }
                }
                .frame(width: 150)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .cornerRadius(PCBButton.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 2)
                )
            }
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.google) {
                Button("Google Maps") {
                    if userAgreedDirectionsDisclaimer {
                        DirectionsProvider.shared.select(mappingApp: .google)
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(true)
                    }
                }
                .foregroundColor(.accentColor)
                .frame(width: 150)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .cornerRadius(PCBButton.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 2)
                )
            }
            if DirectionsProvider.shared.supportedMappingApps.contains(DirectionsProvider.MappingApp.waze) {
                Button("Waze") {
                    if userAgreedDirectionsDisclaimer {
                        DirectionsProvider.shared.select(mappingApp: .waze)
                        presentationMode.wrappedValue.dismiss()
                        self.showDirections?(true)
                    }
                }
                .frame(width: 150)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .cornerRadius(PCBButton.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 2)
                )
            }
        }
        .foregroundColor(.accentColor)
    }
}

struct DisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsDisclaimerView()
            .preferredColorScheme(.light)
        DirectionsDisclaimerView()
            .preferredColorScheme(.dark)
    }
}
