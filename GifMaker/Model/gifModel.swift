//
//  gifModel.swift
//  GifMaker
//
//  Created by LEADS Corporation Limited on 10/5/24.
//

import Foundation
// MARK: - Data Models

struct Gif: Codable {
    let id: String
    let title: String
    let images: GifImages
}

struct GifImages: Codable {
    let fixedHeight: GifImageData
    let original: GifImageData
    
    enum CodingKeys: String, CodingKey {
        case fixedHeight = "fixed_height"
        case original
    }
}

struct GifImageData: Codable {
    let url: String
}

struct GiphyRandomGifResponse: Codable {
    let data: Gif
}

struct GiphySearchGifResponse: Codable {
    let data: [Gif]
}
