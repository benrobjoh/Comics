//
//  MarvelAPIClient.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation
import CryptoKit

public class MarvelAPIClient {
    public let keyStore: KeyStore
    public let session: URLSession
    
    public init(keyStore: KeyStore,
                session: URLSession = .shared) {
        self.keyStore = keyStore
        self.session = session
    }

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

    public func executeRequest<T: APIRequestConfiguration>(_ configuration: T) async throws {

    }
}
