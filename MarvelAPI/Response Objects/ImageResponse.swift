//
//  ImageResponse.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public struct ImageResponse: Decodable {
    enum Variant: String {
        case small = "portrait_small"
        case medium = "portrait_medium"
        case xlarge = "portrait_xlarge"
        case fantastic = "portrait_fantastic"
        case uncanny = "portrait_uncanny"
        case incredible = "portrait_incredible"
    }
    public var path: String?
    public var `extension`: String?
}
