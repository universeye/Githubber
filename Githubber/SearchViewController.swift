//
//  SearchViewController.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit

class SearchViewController: UIViewController {
    
    //initialize objects needed
    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers") //CTA button
    let assets = Assets() //for constants
    
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
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func createDismissKBTappedGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureLogoImageView() {
        //addSubView = grabbing a UIImageView out of the library, dragging it on to viewController and dropping it
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: assets.ghlogo) { //set the image to gh-logo
            logoImageView.image = image
        }
        NSLayoutConstraint.activate([ //at least 4 constraints on an object
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80), //Y
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), //X
            logoImageView.heightAnchor.constraint(equalToConstant: 200), //Height
            logoImageView.widthAnchor.constraint(equalToConstant: 200) //Width
        ])
    }
    
    
    func configureTextField() {
        view.addSubview(userNameTextField)
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50), //trailing or bottom anchor have to be negative
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCTAButton() {
        view.addSubview(callToActionButton)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


extension SearchViewController: UITextFieldDelegate {
    
    
}
