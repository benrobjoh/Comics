//
//  ResponseDecodingTests.swift
//  MarvelAPITests
//
//  Created by Ben Johnson on 2022-05-28.
//

import XCTest
import MarvelAPI

class ResponseDecodingTests: XCTestCase {
    func testDecodingComicResponse() throws {
        guard let url = Bundle(for: Self.self)
            .url(forResource: "Comic", withExtension: "json") else {
            XCTFail("Cannot find sample comic response")
            return
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(ResponseWrapper<ComicResponse>.self,
                                          from: data)
        XCTAssertEqual(response.code, 200)
        XCTAssertEqual(response.data?
            .results?.count, 1)
        let comic = try XCTUnwrap(response.data?
            .results?.first)
        XCTAssertEqual(comic.title, "Avengers Vs. X-Men (2012) #1")
        XCTAssertEqual(comic.description, "&bull; It&rsquo;s No Longer Coming&mdash;It&rsquo;s Here!\r\n&bull; Does The Return Of The Phoenix To Earth Signal The Rebirth Of The Mutant Species? That&rsquo;s What The X-Men Believe! \r\n&bull; Unfortunately, The Avengers Are Convinced That Its Coming Will Mean The End Of All Life On Earth!\r\n&bull; The Stage Is Set For The Ultimate Marvel Showdown In This Oversized First Issue!")
        let thumbnail = try XCTUnwrap(comic.thumbnail)
        XCTAssertEqual(thumbnail.path, "http://i.annihil.us/u/prod/marvel/i/mg/d/90/4f7dc878b57fe")
        XCTAssertEqual(thumbnail.extension, "jpg")
    }
}
