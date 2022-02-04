//
//  OBScreenA.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/27/22.
//

import SwiftUI

struct OBScreenA: View {
    var body: some View {
        Text("Pittsburgh City Bridges app provides access to a City of Pittsburgh Bridges Open Data dataset hosted by the Western Pennsylvania Regional Data Center. There are over 140 bridges, not all are vehicle bridges, a few are foot bridges.")
            .multilineTextAlignment(.leading)
            .padding()
            // image
    }
}

struct OBScreenA_Previews: PreviewProvider {
    static var previews: some View {
        OBScreenA()
    }
}
