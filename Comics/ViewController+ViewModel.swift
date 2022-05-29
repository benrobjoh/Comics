//
//  ViewController+ViewModel.swift
//  Comics
//
//  Created by Ben Johnson on 2022-05-29.
//

import Foundation
import MarvelAPI
import UIKit
import CryptoKit

extension ViewController {
    class ViewModel: ObservableObject {
        @Published var isSyncInProgress = false

        @Published var comicInfo: NSAttributedString?
        @Published var coverImage: UIImage?
        private var client = MarvelAPIClient(keyStore: InMemoryKeyStore())

        func loadComic(id: String) async throws {
            let configuration = ComicRequestConfiguration(comicId: id)
            let wrapper = try await client.executeRequest(configuration)
            if let comic = wrapper.data?.results?.first {
                updateComicInfo(comic: comic, attributionHTML: wrapper.attributionHTML)
            }
            if let thumbnail = wrapper.data?.results?.first?.thumbnail {
                let image = try await client.executeImageRequest(from: thumbnail,
                                                                  variant: .uncanny)
                updateCoverImage(image)
            }
        }

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

        func updateCoverImage(_ image: UIImage?) {
            coverImage = image
        }

        func updateKeys(publicKey: String,
                        privateKey: String) {
            client.keyStore = InMemoryKeyStore(publicKey: publicKey,
                                                  privateKey: privateKey)
        }

        func resetKeys() {
            client.keyStore = InMemoryKeyStore()
        }
    }
}
