//
//  CarouselCollectionViewCell.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    let layout = CarouselCollectionViewFlowLayout()
    let collectionView: UICollectionView
    var movies = [Movie]()
    let viewModel = DiscoveryViewModel()

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        super.init(frame: frame)

        layout.scrollDirection = .horizontal

        let height = collectionView.bounds.height
        let width = (height * 2) / 3
        layout.itemSize = .init(width: width, height: height)
        layout.numberOfItems = 10
        layout.numberOfSections = Int(Int16.max) / layout.numberOfItems

        collectionView.register(UINib(nibName: "DiscoveryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        collectionView.showsHorizontalScrollIndicator = false

        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.addSubview(collectionView)

        viewModel.delegate = self

        viewModel.fetchMovies()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarouselCollectionViewCell: DiscoveryDelegate {
    func didUpdateMovies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension CarouselCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        layout.numberOfSections
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DiscoveryCollectionViewCell
        if let movie = viewModel.getMovie(index: indexPath.row) {
            cell.setImageUrl(movie.poster_path)
        }
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCategory(index: indexPath.row)
    }
}
