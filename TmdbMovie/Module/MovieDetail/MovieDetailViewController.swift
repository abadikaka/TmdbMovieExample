//
//  MovieDetailViewController.swift
//  TmdbMovie
//
//  Created by Michael Abadi Santoso on 7/29/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import UIKit

/// Class for detail information
final class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var handleLike: UIButton!
    
    // FIXME: Put in viewmodel
    private var information: MovieModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .lightGray
        setupView()
    }
    
    private func setupView() {
        guard let model = information else { return }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let url = model.thumbnail else {
                return
            }
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = UIImage(data: data)
                }
            } catch {
                print(error)
            }
        }
        releaseDate.text = "Release Date: \(model.releaseDate)"
        textView.text = model.synopsis
        rating.text = "Rating: \(model.rating)"
        titleLabel.text = model.title
        handleLike.backgroundColor = model.isFavorite ? .blue : .lightGray
        handleLike.setTitle(model.isFavorite ? "Liked" : "Like This", for: .normal)
        handleLike.tintColor = model.isFavorite ? .white : .blue
    }
    
    func setup(information: MovieModel) {
        self.information = information
    }
    
    @IBAction func handleLikeButton(_ sender: Any) {
        // FIXME: Put in viewmodel
        guard let model = information else { return }
        let databaseManager = MovieDatabaseManager()
        databaseManager.setFavorite(model.id)
        // FIXME: Encapsulate this one base on db change this is hardcoded
        handleLike.backgroundColor = model.isFavorite ? .lightGray : .blue
        handleLike.setTitle(model.isFavorite ? "Like This" : "Liked", for: .normal)
        handleLike.tintColor = model.isFavorite ? .blue : .white
    }
    
}
