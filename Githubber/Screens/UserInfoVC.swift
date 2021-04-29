//
//  UserInfoVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/29.
//

import UIKit

class UserInfoVC: UIViewController {
    
    //MARK: - Properties

    let headerView = UIView()
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
        
        configureTestLabel()
        
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
                    self.addChildVC(childViewC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened 2😵", messgae: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    //MARK: - UIStuff

    
    func layOutUI() {
        view.addSubview(headerView)
        
        headerView.backgroundColor = .systemBackground
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
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
