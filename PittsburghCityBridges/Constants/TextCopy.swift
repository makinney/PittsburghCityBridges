//
//  TextCopy.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/3/22.
//

import Foundation

struct AppTextCopy {
    struct SortedBySection {
        static let neighborhood = "Neighborhood"
        static let name = ""
        static let year = "Year built: "
    }
    
    static let directionDisclaimerAgreement = """
The mapping, directions and bridge data is presented solely as a convenience browser to publically accessible open data.

No representation is made or warranty given as to data content, route practicability or efficiency, or map accuracy.

User assumes all risk of use. App maker assumes no legal liability or responsibility for any loss, damage, injury, or delay associated with the use of this product.
"""
    static let onBoardingIntroFirstPart = """
Pittsburgh City Bridges app contains vehicle bridges, pedestrian bridges and more.  The other 140 cross land, ravines, creeks, roads, train lines, all within the City of Pittsburgh boundaries. Most if not all of the photos are from the City of Pittsburgh dataset.

The bridge data is organized as lists, maps, and photos. Sortable by bridge name, neighorhood, or year built and filtered by favorites.
"""
    
    static let onboardingOpenDataSource = """
This app uses the City of Pittsburgh Bridges Open Data dataset provided by the [Western Pennsylvania Regional Data Center](http://www.wprdc.org). The WPRDC hosts over 300 publically available Open Data datasets.

The dataset contains over 140 bridges of various sizes, types and shapes. Only 2 of the 140 cross a river. These are City Bridges.

"""
    static let onBoardingCloseScreen = """
No representation is made or warranty given as to app data content, including bridge names, year built, locations, photos, route practicability, efficiency, or map accuracy.
"""
}


