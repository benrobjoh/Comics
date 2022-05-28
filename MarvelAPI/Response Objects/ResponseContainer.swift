//
//  ResponseContainer.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public struct ResponseContainer<T: Decodable>: Decodable {
    public var results: [T]?
}
