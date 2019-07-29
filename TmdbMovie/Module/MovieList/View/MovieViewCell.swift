//
//  MovieViewCell.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 24/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import UIKit

class MovieViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .lightGray
        spinner.startAnimating()
    }

    func configCell(model: MovieModel) {
        guard let url = model.thumbnail else {
            spinner.stopAnimating()
            return
        }
        spinner.isHidden = false
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        } catch {
            spinner.stopAnimating()
        }
        
    }
    
}
