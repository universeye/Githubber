//
//  UIViewController+Extension.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/27.
//

import UIKit

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, messgae: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: messgae, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
