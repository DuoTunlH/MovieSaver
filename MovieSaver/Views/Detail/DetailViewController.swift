//
//  DetailViewController.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

private let similarCell = "similarCell"
private let detailReusableView = "detailReusableView"

class DetailViewController: ViewController {
    @IBOutlet var collectionView: UICollectionView!
    var viewModel = DetailViewModel()
    var favouriteBtn: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel.delegate = self
        viewModel.fetchSimilarMovies()
        viewModel.fetchTrailers()
        viewModel.fetchIsFavourite()
    }

    convenience init(movie: Movie) {
        self.init()

        viewModel.setMovie(movie)
    }

    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SimilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: similarCell)
        collectionView.register(UINib(nibName: "DetailReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: detailReusableView)

        favouriteBtn = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(toggleFavourite))

        navigationItem.rightBarButtonItem = favouriteBtn
    }

    @objc func toggleFavourite() {
        viewModel.toggleFavourite()
    }
}

extension DetailViewController: DetailDelegate {
    func didUpdateFavourite(isFavourite: Bool) {
        DispatchQueue.main.async {
            let imageName = isFavourite ? "heart.fill" : "heart"
            self.favouriteBtn?.image = UIImage(named: imageName)
        }
    }

    func didUpdateSimilarMovies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func didUpdateTrailer() {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.numberOfMovies()
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: similarCell, for: indexPath) as! SimilarCollectionViewCell
        if let movie = viewModel.getSimilarMovies(index: indexPath.row) {
            cell.setImageUrl(movie.poster_path)
        }
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 3 * 6) / 3, height: 3 * (UIScreen.main.bounds.width - 3 * 5) / 3 / 2)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: detailReusableView, for: indexPath) as! DetailReusableView
            if let movie = viewModel.getMovie() {
                header.setMovie(movie)
            }
            if let trailer = viewModel.getTrailer() {
                header.setTrailer(trailer)
            }

            return header
        default:
            fatalError()
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.getSimilarMovies(index: indexPath.row) else { return }
        let vc = DetailViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: 0)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}
