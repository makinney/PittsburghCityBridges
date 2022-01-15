//
//  CreditsScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/15/22.
//

import SwiftUI

struct CreditsScreenView: View {
    var body: some View {
        VStack {
            Text("Credits")
            .padding()
            HStack {
            Image("aidensIcon")
                    .cornerRadius(4)
                    .padding([.trailing])
             Text("App Icon by Aidan K.")
                    .padding(.trailing)
            }
            .padding()
            .border(Color.pbTextFgndConcrete, width: 1)
            .cornerRadius(4.0)
            Spacer()
        }    }
}

struct CreditsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsScreenView()
    }
}
