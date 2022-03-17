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
        ZStack {
            Color.pbBgnd
            VStack{
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
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Open Data Source")
            .background(Color.pbBgnd)
            }
        }
    }
    
    private func openDataCredit() -> some View {
        VStack {
            ZStack {
                VStack(alignment: .leading){
                    Text("This App uses the City of Pittsburgh Bridges Open Data dataset provided by  the [Western Pennsylvania Regional Data Center](http://www.wprdc.org). This bridge data includes names, locations, gps coordinates and photos. This dataset is one of over 300 publicly available Open Data datasets provided by the WPRDC")
                        .font(.body)
                        .padding(.bottom, 10)
                    Text(AppTextCopy.wprdcDescription)
                        .font(.body)
                }
                .multilineTextAlignment(.leading)
                .foregroundColor(.pbTextFnd)
            }
        }
    }
}

struct OpenDataCredits_Previews: PreviewProvider {
    static var previews: some View {
        OpenDataCreditsScreen()
        OpenDataCreditsScreen()
            .preferredColorScheme(.dark)
    }
}
