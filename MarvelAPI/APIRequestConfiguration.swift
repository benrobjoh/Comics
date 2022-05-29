//
//  APIRequestConfiguration.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

/// Types used to configure a request to the Marvel API with a JSON response
public protocol APIRequestConfiguration {
    associatedtype Response: Decodable

    /// HTTP method
    var httpMethod: String { get }

    /// Path of the request
    var path: String { get }

    /// Decodes the response data for requests configured with this configuration instance
    /// - Parameter data: The data to be decoded
    /// - Returns: The decoded response
    func decodeResponse(_ data: Data) throws -> Response
}

public extension APIRequestConfiguration {
    func decodeResponse(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self,
                                  from: data)
    }
}
