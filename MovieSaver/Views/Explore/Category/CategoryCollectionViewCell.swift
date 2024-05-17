//
//  CategoryCollectionViewCell.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 16
    }

    override var isSelected: Bool {
        willSet(newValue) {
            super.isSelected = newValue
            label.textColor = newValue ? .white : .black
            backgroundColor = newValue ? .black : .white
        }
    }
}
