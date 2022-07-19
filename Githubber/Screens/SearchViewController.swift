//
//  SearchViewController.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Properties

    //initialize objects needed
    private let logoImageView = UIImageView()
    private let userNameTextField = GFTextField()
    private let callToActionButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3") //CTA button
    private let assets = Assets() //for constants
    
    private var isUsernameEntered: Bool {
        !userNameTextField.text!.isEmpty
    }
    
    //MARK: - Appss LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCTAButton()
        createDismissKBTappedGesture()
    }
    
    //this gets called everytime the view appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Functional

    private func createDismissKBTappedGesture() { //tap anywhere, the keyboard dismiss
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pushFollowerListVC() { //push a new viewController on to the stack
        
        guard isUsernameEntered else {
            print("User name is empty")
            presentGFAlertOnMainThread(title: "Empty Username", messgae: "Please answer a username", buttonTitle: "Ok")
            return
        }
        
        userNameTextField.resignFirstResponder()
        let followerListVC = FollowerListVC(username: userNameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
//Push to SwiftUI alert view testing.
//    func pushAlertView() {
//        let alertView = UIHostingController(rootView: AlertView())
//        navigationController?.pushViewController(alertView, animated: true)
//
//    }
    //MARK: - UI Configuration

    
    private func configureLogoImageView() {
        //addSubView = grabbing a UIImageView out of the library, dragging it on to viewController and dropping it
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: assets.ghlogo) { //set the image to gh-logo
            logoImageView.image = image
        }
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([ //at least 4 constraints on an object
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant), //Y
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), //X
            logoImageView.heightAnchor.constraint(equalToConstant: 200), //Height
            logoImageView.widthAnchor.constraint(equalToConstant: 200) //Width
        ])
    }
    
    
    private func configureTextField() {
        view.addSubview(userNameTextField)
        userNameTextField.delegate = self //self means searchVC
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50), //trailing or bottom anchor have to be negative
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureCTAButton() {
        view.addSubview(callToActionButton)
        
        
        //Button pressed here
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


//MARK: - UITextFieldDelegate


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        pushFollowerListVC()
        return true
    }
    
}
