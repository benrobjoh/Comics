//
//  APIRequestConfiguration.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public protocol APIRequestConfiguration {
    associatedtype Response: Decodable

    var httpMethod: String { get }

    var path: String { get }

    func decodeResponse(_ data: Data) throws -> Response
}

public extension APIRequestConfiguration {
    func decodeResponse(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self,
                                  from: data)
    }
}
