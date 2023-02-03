//
//  ImageListApi.swift
//  Image Browser
//
//  Created by Giri Bahari on 02/02/23.
//

import Foundation

protocol ImageListDelegate {
    func fetch(page: Int, limit: Int, completion: @escaping(_ status: Bool, _ images: ImageListResponse, _ error: ApiError?) -> Void)
}

class ImageListApi: ImageListDelegate {
    func fetch(page: Int, limit: Int, completion: @escaping (Bool, ImageListResponse, ApiError?) -> Void) {
        var urlComponent = URLComponents(string: Config.shared.baseUrl.appending("/v2/list"))!
        urlComponent.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]

        let urlRequest = URLRequest(url: urlComponent.url!)
        Service.shared.call(request: urlRequest) { (result: Result<ImageListResponse, ApiError>) in
            switch result {
            case .success(let imageList):
                completion(true, imageList, nil)
            case .failure(let failure):
                completion(false, ImageListResponse(), failure)
            }
        }
    }
}
