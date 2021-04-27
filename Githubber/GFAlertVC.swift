//
//  GFAlertVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit


class GFAlertVC: UIViewController {
    
    //MARK: - Properties

    let containerView = UIView()
    private let assets = Assets()
    
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLable(textAlignment: .center)
    let actionButton = GFButton(backgroundColor: .systemPink, title: "Ok")

    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    //MARK: - Initializers

    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - App Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = assets.transblack
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    
    //MARK: - Functional
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    
    //MARK: - UI Configuration

    func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor), //center vertically
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
    
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: assets.padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: assets.padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -assets.padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        
        actionButton.setTitle(buttonTitle ?? "Ok" , for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -assets.padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: assets.padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -assets.padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -assets.padding),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: assets.padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -assets.padding)
        ])
    }
}
