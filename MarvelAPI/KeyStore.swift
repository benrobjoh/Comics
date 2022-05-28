//
//  KeyStore.swift
//  MarvelAPI
//
//  Created by Ben Johnson on 2022-05-28.
//

import Foundation

public protocol KeyStore {
    var publicKey: String? { get set }
    var privateKey: String? { get set }
}
