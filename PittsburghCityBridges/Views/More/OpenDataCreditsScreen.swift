//
//  OpenDataCredits.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/18/22.
//

import SwiftUI

struct OpenDataCreditsScreen: View {
    private let cardWidth: CGFloat = 350
    private let strokeColor = Color.pbTextFnd
    private let strokeWidth = 2.0
    private let strokeOpacity = 0.9
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    openDataCredit()
                        .frame(minHeight: 200)
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Open Data Source")
        .background(Color.pbBgnd)
    }
    
    private func openDataCredit() -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(lineWidth: strokeWidth)
                    .fill(strokeColor)
                    .opacity(strokeOpacity)
                VStack(alignment: .leading){
                    Text("This App uses the City of Pittsburgh Bridges Open Data dataset provided by  the [Western Pennsylvania Regional Data Center](http://www.wprdc.org). This bridge data includes names, locations, gps coordinates and photos. This dataset is one of over 300 publicly available Open Data datasets provided by the WPRDC")
                        .font(.body)
                        .foregroundColor(.pbTextFnd)
                        .multilineTextAlignment(.leading)
                    
                }
                .padding()
            }
        }
    }
}

struct OpenDataCredits_Previews: PreviewProvider {
    static var previews: some View {
        OpenDataCreditsScreen()
    }
}
