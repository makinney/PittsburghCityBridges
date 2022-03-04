//
//  SortAndSearch.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 3/3/22.
//

import SwiftUI

struct OnBoardingSortAndSearchScreen: View {
    let titleText = """
"Sort and Search by Name, Neighborhood, Year Built"
"""
    var imageSize = (width: 0.0, height: 0.0)
    
    init() {
        let  userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        imageSize = (userInterfaceIdiom == .phone) ? (width: 250.0, height: 250.0) : (width: 400, height: 400)
    }
    var body: some View {
        VStack() {
            Spacer()
            Text("Search and Sort by Name, Neighborhood, or Year Built")
                .font(.headline)
                .padding()
                .multilineTextAlignment(.leading)
            Text("Bridge List Sort and Search")
            Image("sortList")
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
                .frame(width: imageSize.width, height: imageSize.height)
                .padding(.bottom, 20)
            Text("Bridge Photos Sort and Search")
            Image("sortPhotos")
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
                .frame(width: imageSize.width, height: imageSize.height)
            Spacer()
        }
    }
}

struct SortAndSearch_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingSortAndSearchScreen()
    }
}
