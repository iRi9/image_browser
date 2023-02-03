//
//  Service.swift
//  Image Browser
//
//  Created by Giri Bahari on 02/02/23.
//

import UIKit

enum ApiError: String, Error {
    case invalidApiKey = "Invalid API key: You must be granted a valid key"
    case invalidService = "Invalid service: this service does not exist"
    case noData = "Data not found"
    case failDecodeResponse = "Failed decode JSON"
}

class Service {
    static let shared = Service()
    private init() {}

    // MARK: - Request API
    func call<T: Decodable>(request: URLRequest, _ completion: @escaping(Result<T, ApiError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(.failure(.invalidService))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let dataObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataObject))
                }
            } catch {
                completion(.failure(.failDecodeResponse))
            }
        }
        task.resume()
    }

    // MARK: - Image downloader
    func downloadImage(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
            }

            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                completion(data, nil)
            }
        }.resume()
    }
}
