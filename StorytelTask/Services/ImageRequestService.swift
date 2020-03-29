//
//  ImageRequestService.swift
//  StorytelTask
//
//  Created by ChrisTappin on 26/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

/**
 Image request errors
 */
enum ImageError: Error {
    case notFound
    case unknownError
    case imageError
}

/**
 Service to obtain images
 */
class ImageRequestService {
    var restController: RestControllerProtocol
    
    init(restController: RestControllerProtocol = RestController()) {
        self.restController = restController
    }
    
    /**
     Gets the image from the url
     
     - parameters:
        - url: The url of the image
        - completion: The completion handler
     */
    func getResults(url: URL, completion: @escaping (Result<Data, ImageError>) -> Void) {
        
        let imageRequest = ImageRequest(url: url)
        self.restController.send(imageRequest, completionHandler: { result in
            switch result {
            case .failure(_):
                completion(.failure(.imageError))
            case .success(let response):
                completion(.success(response))
            }
        })
    }
}
