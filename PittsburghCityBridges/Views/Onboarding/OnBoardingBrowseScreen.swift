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
            Text("Find Bridges")
                .font(.title2)
                .padding(.bottom, 30)
            Text("By location in a Map")
                .padding(.bottom, 10)
            Image(systemName: "map")
                .font(.title)
                .foregroundColor(.accentColor)
                .padding(.bottom, 20)
            Text("From Photos of Bridges")
                .padding(.bottom, 10)
            Image(systemName: "photo.on.rectangle")
                .font(.title)
                .foregroundColor(.accentColor)
                 .padding(.bottom, 20)
            Text("In a List of Bridges")
                .padding(.bottom, 10)
            Image(systemName: "list.dash")
                .font(.title)
                .foregroundColor(.accentColor)
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
