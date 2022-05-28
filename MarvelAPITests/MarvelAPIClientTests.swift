//
//  MarvelAPITests.swift
//  MarvelAPITests
//
//  Created by Ben Johnson on 2022-05-28.
//

import XCTest
@testable import MarvelAPI

class MarvelAPIClientTests: XCTestCase {

    // Test that the query parameters match the example at https://developer.marvel.com/documentation/authorization
    func testGenerateAuthenticationQueryParameters() throws {
        let keyStore = InMemoryKeyStore(publicKey: "1234",
                                        privateKey: "abcd")
        let client = MarvelAPIClient(keyStore: keyStore)

        let date = Date(timeIntervalSince1970: 1)
        let queryItems = try client.authorizationQueryItems(requestDate: date)
        XCTAssertEqual(queryItems.count, 3)

        let timestamp = queryItems.first { $0.name == "ts" }
        let timestampValue = try XCTUnwrap(timestamp?.value)
        XCTAssertEqual(timestampValue, "1")

        let publicKey = queryItems.first { $0.name == "apikey" }
        let publicKeyValue = try XCTUnwrap(publicKey?.value)
        XCTAssertEqual(publicKeyValue, "1234")

        let hash = queryItems.first { $0.name == "hash" }
        let hashValue = try XCTUnwrap(hash?.value)
        XCTAssertEqual(hashValue, "ffd275c5130566a2916217b101f26150")
    }

    func testEmptyAuthenticationThrows() {
        let keyStore = InMemoryKeyStore(publicKey: nil,
                                        privateKey: "abcd")
        let client = MarvelAPIClient(keyStore: keyStore)

        let date = Date(timeIntervalSince1970: 1)
        XCTAssertThrowsError(try client.authorizationQueryItems(requestDate: date))
    }

    func testGeneratingRequest() throws {
        let keyStore = InMemoryKeyStore(publicKey: "1234",
                                        privateKey: "abcd")
        let client = MarvelAPIClient(keyStore: keyStore)
        let request = try client.configureRequest(ComicRequestConfiguration(comicId: "13"),
                                                  requestDate: Date(timeIntervalSince1970: 1))
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://gateway.marvel.com/v1/public/comics/13?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150")
    }
}
