//
//  ComicRequest.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

/// Configuration for requests to GET https://gateway.marvel.com/v1/public/comics/{comicId}"
public struct ComicRequestConfiguration: APIRequestConfiguration {
    public typealias Response = ResponseWrapper<ComicResponse>

    public let comicId: String

    public let httpMethod = "GET"

    public var path: String {
        "https://gateway.marvel.com/v1/public/comics/\(comicId)"
    }

    public init(comicId: String) {
        self.comicId = comicId
    }
}
