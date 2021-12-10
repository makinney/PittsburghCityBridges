//
//  ImageViewLoader.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/22/21.
//

import Combine
import Files
import SwiftUI
import os
import UIKit

class UIImageLoader: ObservableObject {
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    private var imageFileService: ImageFileService
    private (set)var cachedImageData: Data?
    init() {
        self.imageFileService = ImageFileService()
    }
    
    @MainActor
    func getImageData(for imageURL: URL?) async -> Data? {
        guard let imageURL = imageURL else { return nil }
        var imageData: Data?
        if let cachedImageData = cachedImageData {
            return cachedImageData
        }
        let imageFileName = imageFileName(imageURL)
        let imageFileData = imageFileService.getData(for: imageFileName)
        if let imageFileData = imageFileData {
            imageData = imageFileData
            cachedImageData = imageData
        } else {
            do {
                let (data, response) = try await URLSession.shared.data(from: imageURL)
                logger.debug("\(#file) \(#function) \(response.debugDescription)")
                // persist, e.g. cache this data for future use
                imageData = data
                cachedImageData = data
                imageFileService.save(data: data, to: imageFileName)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
        return imageData
    }
    
    func imageFileName(_ imageURL: URL?) -> String {
        if let name = imageURL?.pathComponents.last {
            return name
        } else {
            logger.info("\(#file) \(#function) error no file name for imageURL \(imageURL.debugDescription) ")
            return ""
        }
    }
}
