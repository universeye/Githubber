//
//  GFUserInfoHeaderVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/29.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {
    
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let userNameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    private let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
    private let locationImageView = UIImageView()
    private let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
    private let bioLabel = GFBodyLable(textAlignment: .left)
    
    private let assets = Assets()
    var user: User!

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        configureUIElement()
        layOut()
        
    }
    
    func configureUIElement() {
        avatarImageView.downloadImage(from: user.avatarUrl)
        userNameLabel.text = user.login
        nameLabel.text = user.name ?? "n/a"
        locationLabel.text = user.location ?? "no location"
        
        bioLabel.text = user.bio ?? "no bio"
        bioLabel.numberOfLines = 3
        
        locationImageView.image = UIImage(systemName: SFSymbols.location)
        locationImageView.tintColor = .secondaryLabel
    }
    
    func addSubview() {
        view.addSubview(avatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
    }
    
    func layOut() {
        let textimagePadding: CGFloat = 12
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: assets.padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: assets.padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textimagePadding),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -assets.padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textimagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -assets.padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textimagePadding),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -assets.padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textimagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -assets.padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
}
