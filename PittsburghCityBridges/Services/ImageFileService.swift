//
//  ImageFileService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/3/21.
//

import Foundation
import Files
import os

class ImageFileService: ObservableObject {
    private let bridgeImagesFolderName = "BridgeImages"
    private var bridgeImagesFolder: Folder?
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
}
