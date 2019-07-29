//
//  MovieViewController.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 24/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var buttonLabel: UILabel!
    
    private var viewModel: MovieViewModelType = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLabel.text = "Sort By Popularity"
        setupCollectionView()
        viewModel.delegate = self
        viewModel.action.loadFirstPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action.loadFirstPage()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func handleButtonClicked(_ sender: Any) {
        if viewModel.datasource.currentSortType == .popularity {
            buttonLabel.text = "Sort By Rating"
            viewModel.action.sort(by: .rating)
        } else {
            buttonLabel.text = "Sort By Popularity"
            viewModel.action.sort(by: .popularity)
        }
    }
    
}

// MARK: UICollectionViewDelegate
extension MovieViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch viewModel.datasource.itemAt(indexPath) {
        case .loading:
            viewModel.action.loadNextPage()
        case .movie(let models):
            let item = models[indexPath.row]
            let cell = cell as? MovieViewCell
            cell?.configCell(model: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.datasource.itemAt(indexPath) {
        case .loading:
            break
        case .movie(let models):
            let item = models[indexPath.row]
        }
    }
}

// MARK: UICollectionViewDataSource
extension MovieViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.datasource.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datasource.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.datasource.itemAt(indexPath) {
        case .loading:
            // FIXME: Change with loading cell
            return collectionView.dequeueReusableCell(withReuseIdentifier: "MovieViewCell", for: indexPath)
        case .movie:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "MovieViewCell", for: indexPath)
        }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension MovieViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ///
        /// This one try to make the cell divided into 2 cells per row
        ///
        var width = (view.bounds.width - 40) / 2
        width -= 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
}

// MARK: MovieViewModelDelegate
extension MovieViewController: MovieViewModelDelegate {
    
    func movieViewModelDidReloadData(_ viewModel: MovieViewModelType) {
        collectionView.reloadData()
    }
    
}
