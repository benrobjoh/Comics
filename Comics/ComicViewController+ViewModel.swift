//
//  ComicViewController+ViewModel.swift
//  Comics
//
//  Created by Ben Johnson on 2022-05-29.
//

import Foundation
import MarvelAPI
import UIKit
import CryptoKit

extension ComicViewController {
    class ViewModel: ObservableObject {
        @Published var isSyncInProgress = false
        @Published var comicInfo: NSAttributedString?
        @Published var coverImage: UIImage?
        @Published var needsAuthorizationKeys: Bool
        let authorizationViewModel = AuthorizationViewModel()
        // Set comicId here
        private var comicId = "41188"
        // Replace nil with keys API keys here or enter when running app
        private var client = MarvelAPIClient(keyStore: InMemoryKeyStore(publicKey: nil,
                                                                        privateKey: nil))

        init() {
            self.needsAuthorizationKeys = client.keyStore.needsKeys
        }
        /// Loads the comic with id = `comicId`
        func loadComic() async {
            isSyncInProgress = true
            defer { isSyncInProgress = false }
            let configuration = ComicRequestConfiguration(comicId: comicId)
            do {
                let wrapper = try await client.executeRequest(configuration)
                if let comic = wrapper.data?.results?.first {
                    updateComicInfo(comic: comic, attributionHTML: wrapper.attributionHTML)
                }
                if let thumbnail = wrapper.data?.results?.first?.thumbnail {
                    let image = try await client.executeImageRequest(from: thumbnail,
                                                                     variant: .uncanny)
                    updateCoverImage(image)
                }
            } catch {
                updateError(error)
            }
        }

        /// Creates an attributed string to display information related to `comic`
        /// - Parameters:
        ///   - comic: The comic whose information should be displayed
        ///   - attributionHTML: The HTML with attribution information
        func updateComicInfo(comic: ComicResponse,
                             attributionHTML: String?) {
            let info = NSMutableAttributedString(string: "")
            if let title = comic.title {
                info.append(
                    NSAttributedString(string: "\(title)\n",
                                       attributes: [
                                        .foregroundColor: UIColor.white,
                                        .font: UIFont.preferredFont(forTextStyle: .title1)
                                       ])
                )
            }
            if let comicDescription = comic.description {
                let data = Data(comicDescription.utf8)
                if let attributedComicDescription = try? NSMutableAttributedString(data: data,
                                                                                   options: [
                                                                                    .documentType: NSAttributedString.DocumentType.html
                                                                                   ],
                                                                                   documentAttributes: nil) {
                    attributedComicDescription.addAttributes([
                        .foregroundColor: UIColor.white,
                        .font: UIFont.preferredFont(forTextStyle: .body)
                    ],
                                                             range: NSRange(location: 0,
                                                                            length: attributedComicDescription.length))
                    info.append(attributedComicDescription)
                    info.append(NSAttributedString(string: "\n"))
                }
            }
            if let attributionHTML = attributionHTML {
                let data = Data((attributionHTML).utf8)
                if let attributedAttributionHTML = try? NSMutableAttributedString(data: data,
                                                                                  options: [
                                                                                    .documentType: NSAttributedString.DocumentType.html
                                                                                  ],
                                                                                  documentAttributes: nil) {
                    attributedAttributionHTML.addAttributes([
                        .font: UIFont.preferredFont(forTextStyle: .caption1)
                    ],
                                                            range: NSRange(location: 0,
                                                                           length: attributedAttributionHTML.length))
                    info.append(attributedAttributionHTML)
                }
            }
            comicInfo = info
        }

        /// Updates the cover image
        /// - Parameter image: The image to set as the cover image
        func updateCoverImage(_ image: UIImage?) {
            coverImage = image
        }

        /// Updates the error information so it shows in place of the comic information
        /// - Parameter error: The error
        func updateError(_ error: Error) {
            comicInfo = NSAttributedString(string: error.localizedDescription,
                                           attributes: [
                                            .foregroundColor: UIColor.white,
                                            .font: UIFont.preferredFont(forTextStyle: .body)
                                           ])
            coverImage = nil
        }

        /// Updates the authorization keys
        /// - Parameters:
        ///   - publicKey: The new `publicKey`
        ///   - privateKey: The new `privateKey`
        func updateKeys(publicKey: String?,
                        privateKey: String?) {
            client.keyStore = InMemoryKeyStore(publicKey: publicKey,
                                               privateKey: privateKey)
            needsAuthorizationKeys = client.keyStore.needsKeys
        }

        /// Deletes the keys currently in the store
        func resetKeys() {
            client.keyStore = InMemoryKeyStore()
            needsAuthorizationKeys = client.keyStore.needsKeys
        }
    }
}
