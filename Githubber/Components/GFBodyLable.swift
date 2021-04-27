//
//  GFBodyLable.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit

class GFBodyLable: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        //lineBreakMode = .byTruncatingMiddle
        translatesAutoresizingMaskIntoConstraints = false
    }

}
