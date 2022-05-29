//
//  ComicViewController.swift
//  Comics
//
//  Created by Ben Johnson on 2022-05-28.
//

import UIKit
import Combine

class ComicViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var keyBarButtonItem: UIBarButtonItem!
    lazy var refreshBarButtonItem: UIBarButtonItem = {
        let refreshItem = UIBarButtonItem(systemItem: .refresh,
                                          primaryAction: UIAction { [weak self] _ in

            Task {
                await self?.viewModel.loadComic()
            }
        })
        refreshItem.tintColor = .white
        return refreshItem
    }()
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    private var cancellables = Set<AnyCancellable>()

    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$needsAuthorizationKeys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] needsKeys in
                guard let self = self else { return }
                if needsKeys {
                    self.presentAuthorization()
                } else {
                    Task {
                        await self.viewModel.loadComic()
                    }
                }
            }.store(in: &cancellables)
        viewModel.$comicInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.detailTextView?.attributedText = info
            }.store(in: &cancellables)
        viewModel.$coverImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.backgroundImageView?.image = image
                self?.coverImageView?.image = image
            }.store(in: &cancellables)
        viewModel.$isSyncInProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSyncing in
                guard let self = self else { return }
                if !isSyncing {
                    self.activityIndicator.stopAnimating()
                    self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem
                } else {
                    self.activityIndicator.startAnimating()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator)
                }
            }.store(in: &cancellables)
    }

    func presentAuthorization() {
        let alertController = UIAlertController(title: viewModel.authorizationViewModel.title,
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { [weak self] textField in
            textField.placeholder = self?.viewModel.authorizationViewModel.publicKeyPlaceholder
        }
        alertController.addTextField { [weak self] textField in
            textField.placeholder = self?.viewModel.authorizationViewModel.privateKeyPlaceholder
            textField.isSecureTextEntry = true
        }
        alertController.addAction(UIAlertAction(title: viewModel.authorizationViewModel.cancelActionTitle,
                                                style: .cancel))
        alertController.addAction(UIAlertAction(title: viewModel.authorizationViewModel.doneActionTitle,
                                                style: .default) { [weak self, alertController] action in
            guard let self = self else { return }
            let publicKey = alertController.textFields?[0].text
            let privateKey = alertController.textFields?[1].text
            self.viewModel.updateKeys(publicKey: publicKey,
                                      privateKey: privateKey)
        })
        present(alertController, animated: true)
    }

    // MARK: - Actions
    @IBAction func authorizationPressed(_ sender: UIBarButtonItem) {
        viewModel.resetKeys()
    }
}

