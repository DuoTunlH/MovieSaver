//
//  String+Localization.swift
//  MovieSaver
//
//  Created by tungdd on 18/05/2024.
//

import Foundation

extension String {
    public func localize(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
