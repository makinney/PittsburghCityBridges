//
//  SearchFieldView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/21/22.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var searchText: String
    var bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping
    var prompt: String = "Search"
    
    var body: some View {
        HStack {
            ZStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                        .padding(.leading, 5)
                    TextField("Search", text: $searchText, prompt: Text(searchPrompt(bridgeInfoGrouping)))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .foregroundColor(Color.pbTextFnd)
                    Button {
                        searchText = ""
                    } label: {
                        Label("Clear", systemImage: "xmark.circle")
                            .labelStyle(.iconOnly)
                    }
                    .padding(.trailing, 5)
                }
                RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                    .stroke(Color.pbTextFnd, lineWidth: 1.0)
                    .frame(maxHeight: 30)
            }
            .padding(.trailing)
        }
        .background(Color.pbBgnd)
    }
    
    private func searchPrompt(_ bridgeInfoGrouping: BridgeListViewModel.BridgeInfoGrouping) -> String {
        var prompt = "Search by"
        switch bridgeInfoGrouping {
        case .name:
            prompt += " Name"
        case .neighborhood:
            prompt += " Neighborhood"
        case .year:
            prompt += " Year Built"
        }
        return prompt
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(searchText: .constant("abc"), bridgeInfoGrouping: .neighborhood)
        SearchFieldView(searchText: .constant("abc"), bridgeInfoGrouping: .neighborhood)
            .preferredColorScheme(.dark)
    }
}
