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
No representation is made or warranty given as to data content, route practicability, efficiency, or map accuracy.

User assumes all risk of use. App maker assumes no legal liability or responsibility for any loss, damage, injury, or delay associated with the use of these services.
"""
    static let onBoardingIntroFirstPart = """
Pittsburgh Pennsylvania has over 440 bridges, the most of any city in the world. This app is a collection of 140 of those bridges. Though many Pittsburgh bridges cross one of the three rivers, the bridges in this app cross valleys, streams and roads. These are so-called City Bridges.
"""
    
    static let onboardingOpenDataSource = """
This Pittsburgh City Bridges App is a data viewer for bridge information contained in the City of Pittsburgh Bridges Open Data dataset. This Open Data is hosted by the Western Pennsylvania Regional Data Center WPRDC at http://www.wprdc.org.

There are over 140 bridges in the City of Pittsburgh Bridges dataset. Data includes bridge name, year built, year rehabbed, neighborhood locations, gps coordinates and photos. All 140 entries have a bridge name, neighborhood, and location. However some entries are missing the year built and some do not have photos.

The 140 bridges in the data are of all types. Swipe left to continue to next page.
"""
    static let wprdcDescription = """
    From the WPRDC home page... The Western Pennsylvania Regional Data Center supports key community initiatives by making public information easier to find and use. The Data Center provides a technological and legal infrastructure for data sharing to support a growing ecosystem of data providers and data users. The Data Center maintains Allegheny County and the City of Pittsburgh’s open data portal, and provides a number of services to data publishers and users. The Data Center also hosts datasets from these and other public sector agencies, academic institutions, and non-profit organizations. The Data Center is managed by the University of Pittsburgh’s Center for Social and Urban Research, and is a partnership of the University, Allegheny County and the City of Pittsburgh
    """
    

    static let onBoardingCloseScreen = """
No representation is made or warranty given as to data content. User assumes all risk of use.
"""
}


