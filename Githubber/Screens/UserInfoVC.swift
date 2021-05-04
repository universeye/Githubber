//
//  UserInfoVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/29.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}


class UserInfoVC: UIViewController {
    
    //MARK: - Properties

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let cardView1 = UIView()
    let cardView2 = UIView()
    let dateLabel = GFBodyLable(textAlignment: .center)
    let upadateDateLabel = GFBodyLable(textAlignment: .center)
    let githublogo = UIImageView()
    
    weak var delegate: UserInfoVCDelegate!
    
    private let assets = Assets()
    var userName : String?
    
    private let detailedTestText = GFBodyLable(textAlignment: .center)
    
    
    
    
    
    //MARK: - App LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        configureScrollView()
        
        layOutUI()
        
        getUserInfo(userName: userName!)
    
        
    }
    
    //MARK: - Logical Function

    
    @objc private func dismissVC () {
        dismiss(animated: true)
    }
    
    private func getUserInfo(userName: String) {
        //print("Getting \(userName)'s userInfo..")
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            self.dimissLoadingView()
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
        
        self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
        self.upadateDateLabel.text = "Last updated: \(user.updatedAt.convertToUpdateDateFormat())"
    }
    
    
    func configureScrollView() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        scrollView.pinToEdge(of: view)
        contentView.pinToEdge(of: scrollView)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 670).isActive = true
    }
    //MARK: - UIStuff

    
    func layOutUI() {
        
        let userInfoViewArray = [headerView, cardView1, cardView2, dateLabel, upadateDateLabel]
        let padding: CGFloat = 20
        let cardHeight: CGFloat = 140
         
        for itemview in userInfoViewArray {
            contentView.addSubview(itemview)
            itemview.translatesAutoresizingMaskIntoConstraints = false
            //itemview.backgroundColor = .systemBackground
            
            NSLayoutConstraint.activate([
                itemview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        view.addSubview(githublogo)
        githublogo.translatesAutoresizingMaskIntoConstraints = false
        githublogo.image = UIImage(named: "avatar-placeholder")
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            cardView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            cardView1.heightAnchor.constraint(equalToConstant: cardHeight),
            
            cardView2.topAnchor.constraint(equalTo: cardView1.bottomAnchor, constant: padding),
            cardView2.heightAnchor.constraint(equalToConstant: cardHeight),
            
            dateLabel.topAnchor.constraint(equalTo: cardView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            githublogo.topAnchor.constraint(equalTo: cardView2.bottomAnchor, constant: padding - 2),
            githublogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding + 2),
            githublogo.widthAnchor.constraint(equalToConstant: 25),
            githublogo.heightAnchor.constraint(equalToConstant: 25),
            
            upadateDateLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: padding),
            upadateDateLabel.heightAnchor.constraint(equalToConstant: 20)
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


//MARK: - Extension

extension UserInfoVC: ItemInfoVCDelegate {
    func didTapGithubProfileBut(for user: User) {
        //show safari viewController
        //print("did tapped github profile")
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
        
        dismissVC()
        //tell followerListVC the new User
        delegate.didRequestFollowers(for: user.login)
        //print("did tapped get followers")
    }
    
    
}
