//
//  ViewController.swift
//  Comics
//
//  Created by Ben Johnson on 2022-05-28.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var keyBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    private var cancellables = Set<AnyCancellable>()

    let model = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            try? await model.loadComic(id: "41188")
        }
        model.$comicInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.detailTextView?.attributedText = info
            }.store(in: &cancellables)
        model.$coverImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.backgroundImageView?.image = image
                self?.coverImageView?.image = image
            }.store(in: &cancellables)
    }

    // MARK: Actions
    
}

