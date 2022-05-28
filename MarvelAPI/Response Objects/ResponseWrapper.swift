//
//  ResponseWrapper.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public struct ResponseWrapper<T: Decodable>: Decodable {
    public var code: Int?
    public var status: String?
    public var attributionHTML: String?
    public var data: ResponseContainer<T>?
}
