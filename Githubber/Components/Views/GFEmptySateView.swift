//
//  GFEmptySateView.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/29.
//

import UIKit

class GFEmptySateView: UIView {
    
    private let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    private let emptySateImageView = UIImageView()
    private let assets = Assets()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(mesage: String) {
        super.init(frame: .zero)
        messageLabel.text = mesage
        configure()
    }
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(emptySateImageView)
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        emptySateImageView.image = UIImage(named: assets.emptyStateImage)
        emptySateImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200), //hard code this
            
            emptySateImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3), //30% larger than the width of the image
            emptySateImageView.heightAnchor.constraint(equalTo: emptySateImageView.widthAnchor),
            emptySateImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            emptySateImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
        
    }
}
