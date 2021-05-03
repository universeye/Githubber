//
//  UserInfoVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/29.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didTapGithubProfileBut(for user: User)
    func didTapGetFollowersBut(for user: User)
}

class UserInfoVC: UIViewController {
    
    //MARK: - Properties

    let headerView = UIView()
    let cardView1 = UIView()
    let cardView2 = UIView()
    let dateLabel = GFBodyLable(textAlignment: .center)
    weak var delegate: followerListVCDelegate!
    
    private let assets = Assets()
    var userName : String?
    
    private let detailedTestText = GFBodyLable(textAlignment: .center)
    
    
    
    
    
    //MARK: - App LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        
        
        layOutUI()
        
        getUserInfo(userName: userName!)
    
        
    }
    
    //MARK: - Logical Function

    
    @objc private func dismissVC () {
        dismiss(animated: true)
    }
    
    private func getUserInfo(userName: String) {
        print("Getting \(userName)'s userInfo..")
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElement(with: user)
                }
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened 2😵", messgae: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElement(with user: User) {
        
        let repoItemVC = GFRepoItemVC(user: user)
        let followerItemVC = GFFollowerItemVC(user: user)
        
        repoItemVC.delegate = self
        followerItemVC.delegate = self
        
        self.addChildVC(childViewC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.addChildVC(childViewC: repoItemVC, to: self.cardView1)
        self.addChildVC(childViewC: followerItemVC, to: self.cardView2)
        
        self.dateLabel.text = "Githun since \(user.createdAt.convertToDisplayFormat())"
    }
    //MARK: - UIStuff

    
    func layOutUI() {
        
        let userInfoViewArray = [headerView, cardView1, cardView2, dateLabel]
        let padding: CGFloat = 20
        let cardHeight: CGFloat = 140
         
        for itemview in userInfoViewArray {
            view.addSubview(itemview)
            itemview.translatesAutoresizingMaskIntoConstraints = false
            //itemview.backgroundColor = .systemBackground
            
            NSLayoutConstraint.activate([
                itemview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            cardView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            cardView1.heightAnchor.constraint(equalToConstant: cardHeight),
            
            cardView2.topAnchor.constraint(equalTo: cardView1.bottomAnchor, constant: padding),
            cardView2.heightAnchor.constraint(equalToConstant: cardHeight),
            
            dateLabel.topAnchor.constraint(equalTo: cardView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func addChildVC(childViewC: UIViewController, to containerView: UIView) {
        addChild(childViewC)
        containerView.addSubview(childViewC.view)
        childViewC.view.frame = containerView.bounds
        childViewC.didMove(toParent: self)
    }
    
    
    
    
    
    //MARK: - Testing

    
    private func configureTestLabel() {
        view.addSubview(detailedTestText)
        detailedTestText.numberOfLines = 3
        detailedTestText.text = userName
        
        NSLayoutConstraint.activate([
            detailedTestText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailedTestText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGithubProfileBut(for user: User) {
        //show safari viewController
        print("did tapped github profile")
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", messgae: "The url attached to this url is invalid", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowersBut(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", messgae: "This user has no followers", buttonTitle: "Ok")
            return
        }
        //dismissVC
        dismissVC()
        //tell followerListVC the new User
        delegate.didRequestFollowers(for: user.login)
        print("did tapped get followers")
    }
    
    
}
