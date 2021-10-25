//
//  ImageViewLoader.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/22/21.
//

import Combine
import os
import UIKit

class UIImageLoader: ObservableObject {
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    enum State {
        case idle
        case loading
        case failed(String)
        case loaded(UIImage)
    }
    
    @Published private(set) var state = State.idle
    @MainActor
    func load(_ imageURL: URL?) {
        Task {
            do {
                guard let imageURL = imageURL else {
                    state = .failed("missing image URL")
                    return
                }
                state = .loading
                let (data, response) = try await URLSession.shared.data(from: imageURL)
                logger.info("\(response.debugDescription)")
                if let image = UIImage(data: data) {
                    state = .loaded(image)
                } else {
                    state = .failed("no Image for \(imageURL)")
                }
            } catch let error {
                logger.error("\(error.localizedDescription)")
                state = .failed(error.localizedDescription)
            }
        }
    }
}
