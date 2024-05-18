//
//  NotificationView.swift
//  MovieSaver
//
//  Created by tungdd on 18/05/2024.
//

import UIKit

class NotificationView: UIView {

    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        alpha = 0
        
        label.textColor = .white

        backgroundColor = .black
        layer.cornerRadius = 18
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 3
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            label
        ])
        stackView.spacing = 8.0
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
    }
    
    func showNotification() {
        var initialFrame = frame
        initialFrame.origin.y = -frame.size.height

        let finalFrame = frame

        frame = initialFrame

        UIView.animate(withDuration: 0.4) {
            [weak self] in
            self?.frame = finalFrame
            self?.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 2.5) {
                [weak self] in
                self?.alpha = 0
            }
        }
    }
}
