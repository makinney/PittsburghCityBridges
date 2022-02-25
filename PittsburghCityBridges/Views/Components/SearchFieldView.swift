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
            ZStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                        .padding(.leading, 5)
                    TextField("Search", text: $searchText, prompt: Text(prompt))
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
                    .stroke(.secondary, lineWidth: 1.0)
                    .frame(maxHeight: 30)
            }
            .padding(.trailing)
        }
        .background(Color.pbTitleTextBgnd)
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(searchText: .constant("abc"), prompt: "Enter Text")
        SearchFieldView(searchText: .constant("abc"), prompt: "Enter Text")
            .preferredColorScheme(.dark)
    }
}
