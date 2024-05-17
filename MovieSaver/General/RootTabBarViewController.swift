//
//  RootTabBarViewController.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

protocol Scrollable {
    func scrollToTop()
}

class RootTabBarViewController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationController?.navigationBar.isHidden = true

        let exploreVC = ExploreViewController()
        let exploreNVC = UINavigationController(rootViewController: exploreVC)
        exploreNVC.tabBarItem.image = UIImage(named: "explore")
        exploreNVC.tabBarItem.title = "Explore"

        let favouriteVC = FavouriteViewController()
        let favouriteNVC = UINavigationController(rootViewController: favouriteVC)
        favouriteNVC.tabBarItem.image = UIImage(named: "profile")
        favouriteNVC.tabBarItem.title = "Favourite"

        setViewControllers([exploreNVC, favouriteNVC], animated: false)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        tabBar.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        // Ensure there are view controllers in the tab bar
        guard let navController = selectedViewController as? UINavigationController else { return }
        
        // Scroll to top if the root view controller is a scrollable view controller
        if let scrollableVC = navController.topViewController as? Scrollable {
            scrollableVC.scrollToTop()
        }
    }
}
