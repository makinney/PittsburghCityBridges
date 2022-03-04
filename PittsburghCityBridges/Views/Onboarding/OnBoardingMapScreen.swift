//
//  OnBoardingMapScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 3/2/22.
//

import SwiftUI

struct OnBoardingMapScreen: View {
    let cornerRadius = 10.0
    let imageName: String
    
    init() {
        imageName = UIDevice.current.userInterfaceIdiom == .phone ? "mapSmall" : "mapBig"
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("This app provides a map of bridge locations and supports directions using Apple Maps, Google Maps, and Waze navigation apps.")
                .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
            .padding()
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .cornerRadius(cornerRadius)
                .overlay( RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.pbTextFnd, lineWidth: 2))
                .frame(width: UIScreen.main.bounds.size.width)
        }
        .padding([.bottom], 60)
        .foregroundColor(.pbTextFnd)
        .background(Color.pbBgnd)
    }
}

struct OnBoardingMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingMapScreen()
    }
}
