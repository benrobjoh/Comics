//
//  KeyStore.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

/// Conforming types can store a public and private key needed to access the Marvel API
public protocol KeyStore {
    var publicKey: String? { get set }
    var privateKey: String? { get set }
}

public extension KeyStore {
    /// Returns `true` if the key store is empty
    var needsKeys: Bool {
        publicKey == nil
        || privateKey == nil
    }
}
