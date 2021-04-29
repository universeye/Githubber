//
//  FollowerCell.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/28.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseID = "FollowerCell"
    
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let userNameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        userNameLabel.text = follower.login
        avatarImageView.downloadImage(from: follower.avatarUrl)
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            //avatarImageView
            //top
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            //left and right, which give us our width base on how wide the cells are
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            //we want the height to equal to thr height bc we want it to be a square
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            
            //userNameLabel
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: padding + 4),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20) //a little larger then the font size
        ])
    }
}
