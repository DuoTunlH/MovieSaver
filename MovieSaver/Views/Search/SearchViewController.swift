//
//  SearchViewController.swift
//  MovieSaver
//
//  Created by tungdd on 19/05/2024.
//

import UIKit

private let movieCell = "movieCell"

class SearchViewController: UIViewController {
    
    var collectionView: UICollectionView!
    let viewModel = SearchViewModel()
    let searchBar = UISearchBar()
    var debounceTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    func setupUI() {
        
        title = "search".localize()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "MoviePosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: movieCell)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: SearchDelegate {
    func didUpdateMovies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCell, for: indexPath) as! MoviePosterCollectionViewCell
        
        if let movie = viewModel.getMovie(index: indexPath.row) {
            cell.setImageUrl(movie.poster_path)
        }
        return cell
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 4 * 6) / 3, height: 3 * (UIScreen.main.bounds.width - 4 * 6) / 3 / 2)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

extension SearchViewController: UISearchBarDelegate {

    
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        debounceTimer?.invalidate()
         
         if searchText.isEmpty {
             viewModel.resetSearch()
             return
         }
         
         if searchText.count >= 3 {
             debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                 self?.viewModel.search(searchText: searchText)
             }
         }
    }
}
