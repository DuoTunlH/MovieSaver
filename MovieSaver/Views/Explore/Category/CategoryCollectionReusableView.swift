//
//  CategoryCollectionReusableView.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class CategoryCollectionReusableView: UICollectionReusableView {
    
    private let viewModel = CategoryViewModel()
    
    let collectionView: UICollectionView
    
    override init(frame: CGRect) {
        var newFrame = frame
        newFrame.origin = .zero
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .init(width: 1, height: 1)
        
        collectionView = UICollectionView(frame: newFrame, collectionViewLayout: layout)
        super.init(frame: newFrame)
        
        self.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        viewModel.delegate = self
        viewModel.fetchCategory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryCollectionReusableView: CategoryDelegate {
  
    func didUpdateCategory() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


extension CategoryCollectionReusableView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
 
        if let genre = viewModel.getGenre(index: indexPath.row) {
            cell.label.text = genre.name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.setSelectedCategory(index: indexPath.row)
    }
    
}
