//
//  ImageResponse.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public struct ImageResponse: Decodable {
    public var path: String?
    public var `extension`: String?
}
