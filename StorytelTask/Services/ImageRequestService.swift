//
//  ImageRequestService.swift
//  StorytelTask
//
//  Created by ChrisTappin on 26/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

enum ImageError: Error {
    case notFound
    case unknownError
    case imageError
}

class ImageRequestService {
    var restController: RestControllerProtocol
    
    init(restController: RestControllerProtocol = RestController()) {
        self.restController = restController
    }
    
    func getResults(url: URL, completion: @escaping (Result<Data, ImageError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }

            if let response = response as? HTTPURLResponse {
                guard 200...299 ~= response.statusCode else {
                    switch response.statusCode {
                    case 404:
                        completion(.failure(.notFound))
                        return
                    default:
                        completion(.failure(.unknownError))
                        return
                    }
                }
            }

            if let data = data {

                completion(.success(data))

            }
            else {
                completion(.failure(.imageError))
            }
        }.resume()
//        let searchRequest = ImageRequest(url: url)
//        self.restController.send(searchRequest, completionHandler: { result in
//            switch result {
//            case .failure(_):
//                completion(.failure(.notFound))
//            case .success(let response):
//                completion(.success(response))
//            }
//        })
    }
}
