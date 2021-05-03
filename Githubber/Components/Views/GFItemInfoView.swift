//
//  GFItemInfoView.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/5/3.
//

import UIKit

enum itemInfoType {
    case reops, gists, followers, following
}

class GFItemInfoView: UIView {
    
    let symbolSFImageView = UIImageView()
    let titleLable = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countlabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set (itemInfoType: itemInfoType, with count: Int) {
        switch itemInfoType {
        
        case .reops:
            symbolSFImageView.image = UIImage(systemName: SFSymbols.folder)
            titleLable.text = "Public Repos"
        case .gists:
            symbolSFImageView.image = UIImage(systemName: SFSymbols.gists)
            titleLable.text = "Public Gists"
        case .followers:
            symbolSFImageView.image = UIImage(systemName: SFSymbols.followers)
            titleLable.text = "Followers"
        case .following:
            symbolSFImageView.image = UIImage(systemName: SFSymbols.following)
            titleLable.text = "Following"
        }
        
        countlabel.text = String(count)
    }
    
    private func configure() {
        addSubview(symbolSFImageView)
        addSubview(titleLable)
        addSubview(countlabel)
        
        symbolSFImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolSFImageView.contentMode = .scaleAspectFill
        symbolSFImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolSFImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolSFImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolSFImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolSFImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLable.centerYAnchor.constraint(equalTo: symbolSFImageView.centerYAnchor),
            titleLable.leadingAnchor.constraint(equalTo: symbolSFImageView.trailingAnchor, constant: 12),
            titleLable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLable.heightAnchor.constraint(equalToConstant: 18),
            
            countlabel.topAnchor.constraint(equalTo: symbolSFImageView.bottomAnchor, constant: 4),
            countlabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countlabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countlabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
