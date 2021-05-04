//
//  Constants.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit


struct Assets {
    var ghlogo = "gh-logo"
    let placeHolderImage = "avatar-placeholder"
    let emptyStateImage = "empty-state-logo"
    let padding: CGFloat = 20
    var transblack: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
}


enum SFSymbols {
    static let location = "mappin.and.ellipse"
    static let folder = "folder"
    static let gists = "text.alignleft"
    static let followers = "heart"
    static let following = "person.2"
}


enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom        = UIDevice.current.userInterfaceIdiom
    static let nativeScale  = UIScreen.main.nativeScale
    static let scale        = UIScreen.main.scale
    
    static let isiPhoneSE           = idiom == .phone && ScreenSize.maxLength == 568
    static let isiPhone8Standard    = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed      = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
    
}
