//
//  UIImage+Extensions.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/11/22.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
