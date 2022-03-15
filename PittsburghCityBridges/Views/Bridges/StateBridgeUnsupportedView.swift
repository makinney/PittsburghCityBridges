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
            Text("It is not in the City of Pittsburgh Bridges database used by this app. It is most likely a State or Federal Bridge")
                .padding()
            HStack(alignment: .bottom) {
                Button("Close") {
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
            Text("State or Federal Bridges near Pittsburgh")
            List(StateBridgesInPittsburgh.stateBridges) {
                Text("\($0.name) Bridge")
                    .font(.body)
                    .listRowBackground(Color.pbTextFnd)
                    .listRowInsets(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            }
            .listStyle(PlainListStyle())
            .foregroundColor(.pbBgnd)
        }
        .background(Color.pbBgnd)
        .foregroundColor(.pbTextFnd)
    }
}

struct StateBridgeUnsupportedView_Previews: PreviewProvider {
    static var previews: some View {
        StateBridgeUnsupportedView(searchText: .constant(""), bridgeName: "Highland Park Bridge")
    }
}
