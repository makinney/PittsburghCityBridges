//
//  MoreScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/3/22.
//

import SwiftUI

struct MoreScreenView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Credits") {
                    CreditsScreenView()
                }
                NavigationLink("Disclaimer") {
                    DirectionsDisclaimerView(disclaimerTextOnly: true, closeTouched: nil)
                }
            }
        }
        //     .navigationTitle("More")
    }
}

struct MoreScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreenView()
            .preferredColorScheme(.dark)
    }
}
