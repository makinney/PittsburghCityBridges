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
            TitleHeader(title: "Credits")
                .padding()
            VStack {
                HStack {
                    Image("aidensIcon")
                        .cornerRadius(4)
                        .padding([.trailing])
                    Text("App Icon by Aidan K.")
                        .padding(.trailing)
                }
                
                HStack {
                        Text("Open Data")
                            .padding(.trailing)
                    Spacer()
                }
                .frame(width: 350, height: 100)
                
                .padding()
                .border(Color.pbTextFgndConcrete, width: 1)
                .cornerRadius(4.0)
                Spacer()
            }
        }
    }
}

struct CreditsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsScreenView()
    }
}
