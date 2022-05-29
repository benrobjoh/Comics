//
//  ComicViewController+AuthorizationViewModel.swift
//  Comics
//
//  Created by Ben Johnson on 2022-05-29.
//

import Foundation

extension ComicViewController {
    class AuthorizationViewModel {
        let title = NSLocalizedString("alert.apiKey.title",
                                      value: "Marvel Comics API Key Required",
                                      comment: "Marvel Comics API Key Required")
        let publicKeyPlaceholder = NSLocalizedString("alert.apiKey.publicKey",
                                                     value: "Public Key",
                                                     comment: "Public Key")
        let privateKeyPlaceholder = NSLocalizedString("alert.apiKey.privateKey",
                                                      value: "Private Key",
                                                      comment: "Private Key")
        let cancelActionTitle = NSLocalizedString("alert.cancel",
                                                  value: "Cancel",
                                                  comment: "Cancel")
        let doneActionTitle = NSLocalizedString("alert.done",
                                                value: "Done",
                                                comment: "Done")
    }
}
