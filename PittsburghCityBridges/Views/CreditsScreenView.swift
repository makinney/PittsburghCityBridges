//
//  CreditsScreenView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/15/22.
//

import SwiftUI

struct CreditsScreenView: View {
    private let cardWidth: CGFloat = 350
    private let strokeColor = Color.pbTextFgndYellow
    private let strokeWidth = 2.0
    private let strokeOpacity = 0.9
    var body: some View {
        ScrollView {
            VStack {
                Text("Credits")
                    .font(.title2)
                    .italic()
                    .foregroundColor(.pbTextFgndYellow)
                VStack {
                    aidensCredit()
                        .frame(minHeight: 100)
                        .padding(.bottom)
                    openDataCredit()
                        .frame(minHeight: 200)
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color.creditscreenBgnd)
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
                Text("Pittsburgh City Bridges App Icon created by Aidan K.")
                    .padding(.trailing)
            }
        }
    }
    
    private func theURL() -> some View {
        Text("The URL")
            .font(.body)
            .onTapGesture {
                print("tapped")
            }
    }
    private func openDataCredit() -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(lineWidth: strokeWidth)
                    .fill(strokeColor)
                    .opacity(strokeOpacity)
                VStack(alignment: .leading){
                    Text("This App uses the City of Pittsburgh Bridges Dataset from the [Western Pennsylvania Regional Data Center](http://www.wprdc.org) for bridge data including descriptions, gps coordinates and photos. This is one of over 300 publicly available so-called Open Data Datasets")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                    
                }
                .padding()
            }
        }
    }
}

struct CreditsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsScreenView()
        CreditsScreenView()
            .preferredColorScheme(.dark)
    }
}
