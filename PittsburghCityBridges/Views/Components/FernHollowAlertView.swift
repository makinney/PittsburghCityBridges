//
//  FernHollowAlertView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 3/11/22.
//

import SwiftUI

struct FernHollowAlertView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            Text("Looking for the Fern Hollow Bridge?")
            Text("Forbes Avenue Frick Park Bridge is the bridge's name in this app.")
                .padding()
            HStack(alignment: .bottom) {
                Button("Show Bridge") {
                    searchText = "Forbes Avenue Frick Park Bridge"
                }
                .frame(width: 150, height: 40)
                .cornerRadius(PCBButton.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 2)
                )
                Button("Cancel Search") {
                    searchText = ""
                }
                .frame(width: 150, height: 40)
                .cornerRadius(PCBButton.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 2)
                )
            }
        }
        .padding()
        .background(Color.pbBgnd)
        .foregroundColor(.pbTextFnd)
    }
    
}

struct FernHollowView_Previews: PreviewProvider {
    static var previews: some View {
        FernHollowAlertView(searchText: .constant("Fern Hollow"))
    }
}
