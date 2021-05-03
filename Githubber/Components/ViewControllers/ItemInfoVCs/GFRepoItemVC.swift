//
//  GFRepoItemVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/5/3.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .reops, with: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroungColor: .systemPurple, title: "Github Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGithubProfileBut(for: user)
    }
    
}
