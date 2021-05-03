//
//  GFButton.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal) //how u properly set a button color, default is white tho
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false //means use autoLayouts
    }
    
    func set(backgroungColor: UIColor, title: String) {
        self.backgroundColor = backgroungColor
        setTitle(title, for: .normal)
    }
}
