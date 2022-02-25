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
        ScrollView {
            VStack {
                Text("App Icon")
                    .font(.title2)
                    .italic()
                    .foregroundColor(.pbTextFnd)
                VStack {
                    aidensCredit()
                        .frame(minHeight: 100)
                        .padding(.bottom)
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color.pbBgnd)
    }
    
    private func aidensCredit() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(lineWidth: strokeWidth)
                .fill(strokeColor)
                .opacity(strokeOpacity)
            HStack {
                Image("aidensIcon")
                    .resizable()
                    .clipped()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
                    .padding(.vertical)
                    .padding([.leading], 20.0)
                Text("Pittsburgh City Bridges App Icon created by 10 year old Aidan K.")
                    .padding(.trailing)
            }
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
