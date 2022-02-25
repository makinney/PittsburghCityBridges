//
//  OnBoardingBrowseScreen.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/8/22.
//

import SwiftUI

struct OnBoardingBrowseScreen: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Browse Bridges As")
                .padding(.bottom, 30)
            Image(systemName: "list.dash")
                .foregroundColor(.accentColor)
                .padding(.bottom, 5)
            Text("Lists")
                .padding(.bottom, 30)
            Image(systemName: "map")
                .foregroundColor(.accentColor)
                .padding(.bottom, 5)
            Text("Map")
                .padding(.bottom, 30)
            Image(systemName: "photo.on.rectangle")
                .foregroundColor(.accentColor)
                .padding(.bottom, 5)
            Text("Photos")
            Spacer()
        }
        .font(UIDevice.current.userInterfaceIdiom == .phone ? .subheadline : .title2)
        .foregroundColor(.pbTextFnd)
    }
}

struct OnBoardingBrowseScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingBrowseScreen()
    }
}
