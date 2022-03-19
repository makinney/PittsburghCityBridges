//
//  FernHollowAlertView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 3/11/22.
//

import SwiftUI

struct FernHollowUnsupportedView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            Text("Looking for the Fern Hollow Bridge?")
            Text("In this app it is named the Forbes Avenue Frick Park Bridge.")
                .padding()
            HStack(alignment: .bottom) {
                Button("Show Bridge") {
                    searchText = "Forbes Avenue Frick Park Bridge"
                }
                .foregroundColor(Color.accentColor)
                .frame(width: 150, height: 40)
                .cornerRadius(PCBButton.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 2)
                )
                Button("Cancel Search") {
                    searchText = ""
                }
                .foregroundColor(Color.accentColor)
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
        FernHollowUnsupportedView(searchText: .constant("Fern Hollow"))
        FernHollowUnsupportedView(searchText: .constant("Fern Hollow"))
            .preferredColorScheme(.dark)
    }
}
