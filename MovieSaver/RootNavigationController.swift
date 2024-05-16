//
//  RootNavigationViewController.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class RootNavigationBarController: UINavigationController {


    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        interactivePopGestureRecognizer?.delegate = self

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
