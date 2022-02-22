//
//  SearchFieldView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 2/21/22.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var searchText: String
    var prompt: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            ZStack {
                HStack {
                    TextField("Search", text: $searchText, prompt: Text(prompt))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Button {
                        searchText = ""
                    } label: {
                        Label("Clear", systemImage: "xmark.circle")
                            .labelStyle(.iconOnly)
                    }
                    .padding(.trailing, 5)
                }
                RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                    .stroke(.secondary, lineWidth: 1.0)
                    .frame(maxHeight: 30)
            }
            
            .padding(.trailing)
        }
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(searchText: .constant("abc"), prompt: "Enter Text")
    }
}
