//
//  RestController.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

/// Rest error types
enum RestError: Error {
    /// 400: Bad Request
    case badRequest

    /// 404: Not Found
    case notFound

    /// JSON decode error
    case decodeError

    /// Anything else
    case unknownError
}

protocol RestURLSession {
    func restTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: RestURLSession {
    func restTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }.resume()
    }

}

/**
 Controller for sending rest requests.
 */
class RestController {

    private let session: RestURLSession

    /**
     Initialises a new RestController with the session provided.

     - Parameters:
        - session: The URLSession to use
     */
    init(session: RestURLSession = URLSession.shared) {
        self.session = session
    }

    /**
     Sends the request

     - Parameters:
        - request:
     */
    func send<Request: RestRequest>(_ request: Request, completionHandler completion: @escaping (Result<Request.ResponseType, RestError>) -> Void) {

        session.restTask(with: request.url) { data, response, error in

            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }

            if let response = response as? HTTPURLResponse {
                guard 200...299 ~= response.statusCode else {
                    switch response.statusCode {
                    case 400:
                        completion(.failure(.badRequest))
                        return
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

                guard let responseData = request.decode(data: data) else {
                    completion(.failure(.decodeError))
                    return
                }

                completion(.success(responseData))

            }
        }
    }
}
