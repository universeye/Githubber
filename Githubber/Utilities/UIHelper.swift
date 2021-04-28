//
//  UIHelper.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/28.
//

import UIKit

struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width //view is the view on the viewController, total width of the screen
        let padding: CGFloat = 12
        let minimunItemSpacing: CGFloat = 10
        var availableWidth: CGFloat {
            width - (padding * 2) - (minimunItemSpacing * 2)
        }
        var itemWidth: CGFloat  {
            return availableWidth / 3
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        
        return flowLayout
    }
}
