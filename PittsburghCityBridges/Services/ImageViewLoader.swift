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

//struct BridgeView: View {
//    @ObservedObject private var imageLoader: UIImageLoader
//
//    var imageURL: URL?
//
//    init(imageLoader: UIImageLoader, imageURL: URL?) {
//        self.imageURL = imageURL
//        self.imageLoader = imageLoader
//    }
//
//    var body: some View {
//        switch imageLoader.state {
//        case .idle:
//            Color.clear
//                .onAppear {
//                    imageLoader.loadBridgeImage(for: imageURL)
//                }
//        case .loading:
//            HStack {
//                Spacer()
//                ProgressView()
//                Spacer()
//            }
//        case .failed(let error):
//            Text(error)
//        case .loaded(let image):
//            Image(uiImage: image)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//        }
//    }
//}

class UIImageLoader: ObservableObject {
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    private var fileServices: FileServices
    enum State {
        case idle
        case loading
        case failed(String)
        case loaded(Data)
    }
    
    init() {
        self.fileServices = FileServices()
    }
    
    @Published private(set) var state = State.idle
    @Published private(set) var uiBridgeImages: [String: Data] = [:]
    
    @MainActor
    
    func clearImageCache(for imageURL: URL?) {
        guard let imageURL = imageURL else {
            return
        }
        let imageFileName = imageFileName(imageURL)
        uiBridgeImages.removeValue(forKey: imageFileName)
    }
    
    @MainActor
    func loadBridgeImage(for imageURL: URL?) {
        Task {
            do {
                guard let imageURL = imageURL else {
                    state = .failed("missing image URL")
                    return
                }
                state = .loading
                // already stored locally?
                let imageFileName = imageFileName(imageURL)
                let existingImageFile: File?  = fileServices.getFile(imageFileName)
                if let existingImageFile = existingImageFile {
                    do {
                        let data = try existingImageFile.read()
                        state = .loaded(data)
                        self.uiBridgeImages[imageFileName] = data
                    } catch {
                        logger.error("\(#file) \(#function) \(error.localizedDescription)")
                    }
                } else {
                    // not stored, fetch it
                    let (data, response) = try await URLSession.shared.data(from: imageURL)
                    logger.info("\(response.debugDescription)")
                    // create a file if need be for this data
                    // persist, e.g. cache this data for future use
                    if existingImageFile == nil {
                        fileServices.createFile(imageFileName, data: data)
                    }
                    state = .loaded(data)
                    self.uiBridgeImages[imageFileName] = data
                }
            } catch let error {
                logger.error("\(error.localizedDescription)")
                state = .failed(error.localizedDescription)
            }
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
