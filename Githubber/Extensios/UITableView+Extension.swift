//
//  UITableView+Extension.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/5/4.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
