//
//  StateBridgeUnsupportedView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 3/15/22.
//

import SwiftUI

struct StateBridgeUnsupportedView: View {
    @Binding var searchText: String
    var bridgeName: String
    var body: some View {
        VStack {
            Text("Looking for the \(bridgeName)?")
            Text("It is not in this app. Only bridges in the Pittsburgh City Bridges database are in this app, which are understood to be bridges whose maintenance is the responsibility of the city.")
                .padding(.horizontal)
                .padding(.vertical, 5)
            HStack(alignment: .bottom) {
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
            .padding(.vertical)
            Text("Major bridges not in the city database")
            List(StateBridgesInPittsburgh.stateBridges) {
                Text("\($0.name) Bridge")
                    .font(.body)
                    .listRowBackground(Color.pbBgnd)
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                
            }
            .listStyle(PlainListStyle())
            .foregroundColor(.pbTextFnd)
        }
        .background(Color.pbBgnd)
        .foregroundColor(.pbTextFnd)
    }
}

struct StateBridgeUnsupportedView_Previews: PreviewProvider {
    static var previews: some View {
        StateBridgeUnsupportedView(searchText: .constant(""), bridgeName: "Highland Park Bridge")
        StateBridgeUnsupportedView(searchText: .constant(""), bridgeName: "Highland Park Bridge")
            .preferredColorScheme(.dark)
    }
}
