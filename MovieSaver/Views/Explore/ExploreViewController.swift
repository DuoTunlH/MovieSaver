//
//  ExploreViewController.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

private let carouselCell = "carouselCell"
private let exploreCell = "exploreCell"
private let categoryHeaderView = "categoryHeaderView"
private let emptyHeaderView = "emptyHeaderView"

class ExploreViewController: ViewController {
    @IBOutlet var exploreCollectionView: UICollectionView!
    
    private let viewModel = ExploreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore 🌎"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let layout = exploreCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        
        exploreCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: exploreCell)
        exploreCollectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: carouselCell)
        exploreCollectionView.register(CategoryCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: categoryHeaderView)
        exploreCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: emptyHeaderView)
        
        viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCarouselItem), name: .didSelectCarouselItem, object: nil)
    }
    
    @objc
    func didSelectCarouselItem(notification: NSNotification) {
        if let movie = notification.object as? Movie {
            let vc = DetailViewController(movie: movie)
            
            navigationController?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ExploreViewController: ExploreDelegate {
    func didSelectCategory() {
        DispatchQueue.main.async {
            self.exploreCollectionView.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func didUpdateMovies() {
        DispatchQueue.main.async {
            self.exploreCollectionView.reloadData()
        }
    }
}

extension ExploreViewController: Scrollable {
    func scrollToTop() {
        exploreCollectionView.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: true)
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.numberOfMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselCell, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: exploreCell, for: indexPath) as! MovieCollectionViewCell
        
        if let movie = viewModel.getMovie(index: indexPath.row) {
            cell.setupNode(movie: movie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 1 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: categoryHeaderView, for: indexPath)
                return header
            } else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: emptyHeaderView, for: indexPath)
            }
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return .init(width: collectionView.bounds.width, height: 60)
        }
        return .zero
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width
        if indexPath.section == 0 {
            return .init(width: cellWidth, height: 345)
        }
        return .init(width: cellWidth, height: 280)
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.getMovie(index: indexPath.row) else { return }
        let vc = DetailViewController(movie: movie)
        
        navigationController?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfMovies() - 6 {
            viewModel.fetchMore()
        }
    }
}
