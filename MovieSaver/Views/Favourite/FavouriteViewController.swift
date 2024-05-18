//
//  FavouriteViewController.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

private let exploreCell = "exploreCell"

class FavouriteViewController: ViewController {
    @IBOutlet var collectionView: UICollectionView!
    let viewModel = FavouriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "favourite".localize()

        navigationController?.navigationBar.prefersLargeTitles = true

        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: exploreCell)

        collectionView.delegate = self
        collectionView.dataSource = self

        viewModel.delegate = self
        viewModel.fetchFavourite()
    }
}

extension FavouriteViewController: FavouriteDelegate {
    func didUpdateMovies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension FavouriteViewController: Scrollable {
    func scrollToTop() {
        collectionView.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: true)
    }
}

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.numberOfMovies()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: exploreCell, for: indexPath) as! MovieCollectionViewCell

        if let movie = viewModel.getMovie(index: indexPath.row) {
            cell.setupNode(movie: movie)
        }
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width
        return .init(width: cellWidth, height: 280)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.getMovie(index: indexPath.row) else { return }
        let vc = DetailViewController(movie: movie)

        navigationController?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
}
