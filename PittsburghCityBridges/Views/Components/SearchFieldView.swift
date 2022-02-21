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
                .padding(.trailing, 5)
            TextField("Search", text: $searchText, prompt: Text(prompt))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(searchText: .constant("abc"), prompt: "Enter Text")
    }
}
