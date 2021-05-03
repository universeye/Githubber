//
//  GFItemInfoVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/5/3.
//

import UIKit

//Generic superClass
class GFItemInfoVC: UIViewController {
    
    let stackView = UIStackView()
    let itemInfoView1 = GFItemInfoView()
    let itemInfoView2 = GFItemInfoView()
    let actionButton = GFButton()
    
    var user: User!
    weak var delegate: UserInfoVCDelegate!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundView()
        configureStackView()
        configureActionButton()
        layoutUI()
        
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {
        
    }
    
    
     private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        //stackView.spacing
        stackView.addArrangedSubview(itemInfoView1)
        stackView.addArrangedSubview(itemInfoView2)
    }
    
    
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let pading: CGFloat = 20
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: pading),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: pading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -pading),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -pading),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: pading),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -pading),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
