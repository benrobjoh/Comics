//
//  InMemoryKeyStore.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public struct InMemoryKeyStore: KeyStore {
    public var publicKey: String?
    public var privateKey: String?
}