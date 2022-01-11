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
    
    let agreementText = """
The mapping, directions and listing information are provided solely for entertainment purposes.

No representation is made or warranty given as to their content, route practicability or efficiency, or map accuracy.

User assumes all risk of use. Supplier assumes no legal liability or responsibility for any loss, damage, injury, or delay associated with the use of this product.

"""
    
    var body: some View {
        GroupBox(label:
                    Label("Legal Disclaimer", systemImage: "building.columns")
        ) {
            ScrollView(.vertical, showsIndicators: true) {
                Text(agreementText)
                    .font(.footnote)
            }
            .frame(height: 200)
            Toggle(isOn: $userAgreedDirectionsDisclaimer) {
                Text("I agree to the above terms")
            }
            .padding()
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
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
