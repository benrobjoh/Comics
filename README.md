# Comics

This comics app queries the [Marvel API](https://developer.marvel.com/docs) and shows information about one comic.

## Running the app

Running the app requires a public and private key for the Marvel API. There are two options to enter your keys.

1. Enter your public and private key in *ComicViewController+ViewModel.swift* in the initializer for the `MarvelAPIClient` on line 23.
2. The app will prompt you to enter a public and private key if you run the app without completing step 1.

Choose which comic's information you would like to view by entering the `comicId` on line 21 of *ComicViewController+ViewModel.swift*.

## Libraries

This app does not use any third-party dependencies. It uses UIKit for the user interface, Combine for binding the view model state to the view, CryptoKit for creating an MD5 hash to authenticate with the Marvel API. The tests use XCTest.