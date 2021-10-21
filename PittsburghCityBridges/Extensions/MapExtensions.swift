//
//  MapExtensions.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//

import MapKit

extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
