//
//  ComicViewModelTests.swift
//  ComicsTests
//
//  Created by Ben Johnson on 2022-05-29.
//

import XCTest
@testable import Comics

class ComicViewModelTests: XCTestCase {

    func testUpdateKeyStore() {
        let viewModel = ComicViewController.ViewModel()
        viewModel.updateKeys(publicKey: "123",
                             privateKey: "abc")
        XCTAssertFalse(viewModel.needsAuthorizationKeys)
    }

    func testDeleteKeyStore() {
        let viewModel = ComicViewController.ViewModel()
        viewModel.updateKeys(publicKey: "123",
                             privateKey: "abc")
        XCTAssertFalse(viewModel.needsAuthorizationKeys)
        viewModel.resetKeys()
        XCTAssertTrue(viewModel.needsAuthorizationKeys)
    }

    func testErrorUpdatesInfo() {
        let viewModel = ComicViewController.ViewModel()
        let error = URLError(.badURL)
        viewModel.updateError(error)
        XCTAssertNil(viewModel.coverImage)
        XCTAssertEqual(viewModel.comicInfo?.string, error.localizedDescription)
    }

}
