//
//  ComicResponse.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public struct ComicResponse: Decodable {
    public var id: Int?
    public var title: String?
    public var description: String?
    public var thumbnail: ImageResponse?
}
