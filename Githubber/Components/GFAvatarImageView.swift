//
//  GFAvatarImageView.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/28.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    private let assets = Assets()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let placeholderImage = UIImage(named: assets.placeHolderImage)
        
        layer.cornerRadius = 10
        clipsToBounds = true //clip thwe image as well
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
