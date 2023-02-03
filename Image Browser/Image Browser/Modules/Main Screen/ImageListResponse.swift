//
//  ImageListResponse.swift
//  Image Browser
//
//  Created by Giri Bahari on 03/02/23.
//

import Foundation

struct ImageResponse: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

typealias ImageListResponse = [ImageResponse]
