//
//  RootNavigationController.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class RootNavigationBarController: UINavigationController {
    
    private let notificationView = NotificationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(notificationView)
        
        NSLayoutConstraint.activate([
            notificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func showNotification(iconName: String, text: String) {
        notificationView.imageView.image = UIImage(named: "check")
        notificationView.label.text = text
        notificationView.showNotification()
    }
}

extension RootNavigationBarController: UINavigationControllerDelegate {
    public func navigationController(_: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        interactivePopGestureRecognizer?.isEnabled = viewControllers.count > 1
    }
}

extension RootNavigationBarController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldBeRequiredToFailBy _: UIGestureRecognizer) -> Bool {
        true
    }
}
