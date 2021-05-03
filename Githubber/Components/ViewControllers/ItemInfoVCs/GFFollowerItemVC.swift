//
//  GFFollowerItemVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/5/3.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .followers, with: user.followers)
        itemInfoView2.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroungColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowersBut(for: user)
    }
}
