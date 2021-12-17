//
//  BridgeImageSystem.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/3/21.
//

import Foundation
import Files
import os
import UIKit

class BridgeImageSystem: ObservableObject {
    private let bridgeImagesFolderName = "BridgeImages"
    private var bridgeImagesFolder: Folder?
    private (set)var cachesFolder: Folder?
    private (set)var cachedImage: UIImage?
    private (set)var cachedThumbnailImage: UIImage?
    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init() {
        let cachesPath = FileManager.cachesDirectoryURL.path
        do {
            cachesFolder = try Folder(path: cachesPath)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            fatalError("\(#file) \(#function) could not create cachesFolder")
        }
        if let cachesFolder = cachesFolder {
            do {
                if !cachesFolder.containsSubfolder(named: bridgeImagesFolderName) {
                    bridgeImagesFolder = try cachesFolder.createSubfolder(named: bridgeImagesFolderName)
                } else {
                    bridgeImagesFolder = try cachesFolder.subfolder(named: bridgeImagesFolderName)
                }
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
                fatalError("\(#file) \(#function) could not create bridgeImagesFolder")
            }
        }
    }
    
    @MainActor
    func getImage(url: URL?) async -> UIImage? {
        if let cachedImage = cachedImage {
            return cachedImage
        }
        if let imageData = await getImageData(for: url) {
            cachedImage = UIImage(data: imageData)
            return cachedImage
        }
        return nil
    }
    
    @MainActor
    func getThumbnailImage(url: URL?, size: CGSize = CGSize(width: 100, height: 100)) async -> UIImage? {
        // SMALL, MIDDLE, LARGE THUMBNAILS FOR ENTIRE APP AND CACHE FOR EACH
        if let cachedThumbnailImage = cachedThumbnailImage {
            return cachedThumbnailImage
        }
        if let imageData = await getImageData(for: url) {
            cachedThumbnailImage = await UIImage(data: imageData)?.byPreparingThumbnail(ofSize: size)
           return cachedThumbnailImage
        }
        return nil
    }
    
    func getImageData(for imageURL: URL?) async -> Data? {
        guard let imageURL = imageURL else { return nil }
        let imageFileName = imageFileName(imageURL)
        if let persistedImageData = getData(for: imageFileName) {
            return persistedImageData
        } else {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                saveToDisk(fileName: imageFileName, data: data)
                return data
            } catch {
                logger.error("\(#file) \(#function) \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func getData(for fileName: String) -> Data? {
        var data: Data?
        if let file = getFile(fileName) {
            do {
                data = try file.read()
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            }
        }
        return data
    }
    
    func getFile(_ named: String) -> File? {
        var file: File?
        do {
            file = try bridgeImagesFolder?.file(named: named)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return file
    }
    
    func imageFileName(_ imageURL: URL?) -> String {
        if let name = imageURL?.pathComponents.last {
            return name
        } else {
            logger.info("\(#file) \(#function) error no file name for imageURL \(imageURL.debugDescription) ")
            return ""
        }
    }
    
    private func saveToDisk(fileName: String, data: Data) {
        var existingFile = getFile(fileName)
        if existingFile == nil {
            do {
                existingFile = try bridgeImagesFolder?.createFile(named: fileName)
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
                fatalError("\(#file) \(#function) could not create image file name \(fileName)")
            }
        }
        do {
            try existingFile?.write(data)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            fatalError("\(#file) \(#function) could not create image file name \(fileName)")
        }
    }
}
