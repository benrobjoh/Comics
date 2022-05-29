//
//  ImageResponse.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public struct ImageResponse: Decodable {
    /// Corresponds to available sizes of images from the API, as documented [here](https://developer.marvel.com/documentation/images)
    public enum Variant: String {
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
