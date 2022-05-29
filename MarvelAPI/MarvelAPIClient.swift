//
//  MarvelAPIClient.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation
import CryptoKit
import UIKit

/// Client that manages interactions with the Marvel Comics API
public class MarvelAPIClient {
    /// Storage for authorization keys
    public var keyStore: KeyStore
    /// Session used to make network requests
    public let session: URLSession

    /// Initializes a new API client
    /// - Parameters:
    ///   - keyStore: The initial key store
    ///   - session: The URL session
    public init(keyStore: KeyStore,
                session: URLSession = .shared) {
        self.keyStore = keyStore
        self.session = session
    }

    // MARK: Authorization
    /// Creates the URL query parameters needed to [authenticate](https://developer.marvel.com/documentation/authorization) with the Marvel Comics API
    /// - Parameter requestDate: The date of the request, defaults to the current time
    /// - Returns: Configured URL query items
    func authorizationQueryItems(requestDate: Date = .now) throws -> [URLQueryItem] {
        guard let publicKey = keyStore.publicKey,
              let privateKey = keyStore.privateKey else { throw URLError(.userAuthenticationRequired) }
        let timestampValue = requestDate.timeIntervalSince1970
            .formatted(.number
                .precision(.fractionLength(0))
                .grouping(.never))
        let timestampItem = URLQueryItem(name: "ts",
                                     value: "\(timestampValue)")
        let publicKeyItem = URLQueryItem(name: "apikey",
                                     value: publicKey)
        let stringToHash = "\(timestampValue)\(privateKey)\(publicKey)"
        guard let dataToHash = stringToHash.data(using: .utf8) else { throw URLError(.userAuthenticationRequired) }
        let hash = Insecure.MD5
            .hash(data: dataToHash)
            .map { String(format: "%02x", $0) }
            .joined()
        let hashItem = URLQueryItem(name: "hash",
                                value: hash)
        return [
            timestampItem,
            publicKeyItem,
            hashItem
        ]
    }

    // MARK: - Comics

    /// Serializes a `URLRequest` from a request configuration
    /// - Parameters:
    ///   - configuration: The request configuration
    ///   - requestDate: The date the request is sent
    /// - Returns: A configured `URLRequest` suitable for use in calling the Marvel Comics API
    public func configureRequest<T: APIRequestConfiguration>(_ configuration: T,
                                                             requestDate: Date = .now) throws -> URLRequest {
        let authenticationQueryItems = try authorizationQueryItems(requestDate: requestDate)
        var components = URLComponents(string: configuration.path)
        var finalQueryItems = components?.queryItems ?? []
        finalQueryItems.append(contentsOf: authenticationQueryItems)
        components?.queryItems = finalQueryItems
        guard let url = components?.url else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = configuration.httpMethod
        return request
    }

    /// Executes a network request with the given configuration, parses the response body, and returns the result
    /// - Parameter configuration: The request configuration
    /// - Returns: The parsed response object from the API
    public func executeRequest<T: APIRequestConfiguration>(_ configuration: T) async throws -> T.Response {
        let request = try configureRequest(configuration)
        let (data, _) = try await session.data(for: request)
        return try configuration.decodeResponse(data)
    }

    // MARK: - Images

    /// Serializes a `URLRequest` for an image
    /// - Parameters:
    ///   - imageResponse: Details about the image needed to configure the request
    ///   - variant: Size of image
    /// - Returns: A configured `URLRequest`
    func configureImageRequest(from imageResponse: ImageResponse,
                               variant: ImageResponse.Variant) throws -> URLRequest {
        guard let path = imageResponse.path,
                let pathExtension = imageResponse.extension else { throw URLError(.badURL) }
        let urlString = "\(path)/\(variant.rawValue).\(pathExtension)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        return URLRequest(url: url)
    }

    /// Requests an image and returns the result
    /// - Parameters:
    ///   - imageResponse: Details about the image needed to configure the request
    ///   - variant: Size of image
    /// - Returns: Image
    public func executeImageRequest(from imageResponse: ImageResponse,
                                    variant: ImageResponse.Variant) async throws -> UIImage? {
        let request = try configureImageRequest(from: imageResponse,
                                                variant: variant)
        let (data, _) = try await session.data(for: request)
        return UIImage(data: data)

    }
}
