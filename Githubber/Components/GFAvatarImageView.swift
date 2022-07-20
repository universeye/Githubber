//
//  GFAvatarImageView.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/28.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    private let assets = Assets()
    let cache = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let placeholderImage = UIImage(named: assets.placeHolderImage)
        
        layer.cornerRadius = 10
        clipsToBounds = true //clip thwe image as well
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
//    func downloadImage(from urlString: String) {
//        
//        let cacheKey = NSString(string: urlString)
//        
//        
//        if let image = cache.object(forKey: cacheKey) {  //forKey has to be unique string
//            self.image = image //if the image is already downloaded, then skip the rest steps
//        }
//        
//        guard let url = URL(string: urlString) else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let self = self else { return }
//            if error != nil {
//                return
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                return
//            }
//            
//            guard let data = data else {
//                return
//            }
//            guard let image = UIImage(data: data) else {
//                return
//            }
//            
//            self.cache.setObject(image, forKey: cacheKey) //save the downloaded image into cache
//            DispatchQueue.main.async { //everytime u wnat to update the ui, u have to do it on the main thread
//                self.image = image
//            }
//        }
//        task.resume()
//    }
    
    
    func downloadImageWithAsync(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {  //forKey has to be unique string
            return image //if the image is already downloaded, then skip the rest steps
        }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
