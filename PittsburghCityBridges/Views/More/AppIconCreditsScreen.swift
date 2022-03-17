//
//  CreditsScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/15/22.
//

import SwiftUI

struct AppIconCreditsScreen: View {
    private let cardWidth: CGFloat = 350
    private let strokeColor = Color.pbTextFnd
    private let strokeWidth = 2.0
    private let strokeOpacity = 0.9
    var body: some View {
        ZStack {
            Color.pbBgnd
            VStack {
                VStack {
                    aidensCredit()
                        .frame(minHeight: 150)
                        .padding()
                    Spacer()
                }
            }
            .background(Color.pbBgnd)
        }
    }
    
    private func aidensCredit() -> some View {
        HStack {
            Image("aidensIcon")
                .resizable()
                .clipped()
                .frame(width: 75, height: 75)
                .cornerRadius(10)
                .padding(.vertical)
                .padding([.leading], 20.0)
            Text("Pittsburgh City Bridges App Icon designed and created by 10 yr old Aidan K.")
                .padding(.trailing)
                .foregroundColor(.pbTextFnd)
        }
    }
}

struct CreditsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconCreditsScreen()
        AppIconCreditsScreen()
            .preferredColorScheme(.dark)
    }
}
