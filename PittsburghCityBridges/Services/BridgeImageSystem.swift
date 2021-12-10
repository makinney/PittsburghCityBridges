//
//  BridgeImageSystem.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/3/21.
//

import Foundation
import Files
import os

class BridgeImageSystem: ObservableObject {
    private let bridgeImagesFolderName = "BridgeImages"
    private var bridgeImagesFolder: Folder?
    private (set)var cachedImageData: Data?
    private var cachesFolder: Folder?
    
    let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
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
    func getImageData(for imageURL: URL?) async -> Data? {
        guard let imageURL = imageURL else { return nil }
        var imageData: Data?
        if let cachedImageData = cachedImageData {
            return cachedImageData
        }
        let imageFileName = imageFileName(imageURL)
        let imageFileData = getData(for: imageFileName)
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
                save(data: data, to: imageFileName)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
        return imageData
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
    
    func save(data: Data, to fileName: String) {
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
    
    func imageFileName(_ imageURL: URL?) -> String {
        if let name = imageURL?.pathComponents.last {
            return name
        } else {
            logger.info("\(#file) \(#function) error no file name for imageURL \(imageURL.debugDescription) ")
            return ""
        }
    }
}
