//
//  NotificationCenter+Name.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation

public extension Notification.Name {
    static let didSelectCategory = Notification.Name("didSelectCategory")
    static let didSelectCarouselItem = Notification.Name("didSelectCarouselItem")
    static let didAddFavourite = Notification.Name("didAddFavourite")
    static let didRemoveFavourite = Notification.Name("didRemoveFavourite")
}
