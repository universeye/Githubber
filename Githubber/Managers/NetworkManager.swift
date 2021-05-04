//
//  NetworkManager.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/27.
//

import UIKit
//vmanot
class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    private init () {
        
    }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> (Void)) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        //print("endpoint is \(endpoint)")
        //URL Error handling
        guard let url = URL(string: endpoint) else {
            print("error 1")
            completion(.failure(.invalidUserName))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                print("error 2, \(err)")
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("error 3")
                completion(.failure(.invalidResponse))
                return
            }
            //print("HTTP Response.statusCode is \(response.statusCode)")
            guard let data = data else {
                print("error 4")
                completion(.failure(.invalidResponse))
                return
            }
            //print(data)
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                //print("success getting followers")
                completion(.success(followers))
            } catch let decodingError {
                print("error 5")
                print(decodingError)
                completion(.failure(.failedToDecode))
            }
            
        }
        
        task.resume()
    }
    
    
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> (Void)) {
        let endpoint = baseURL + "\(username)"
        
        //print("endpoint is \(endpoint)")
        //URL Error handling
        guard let url = URL(string: endpoint) else {
            print("error 1")
            completion(.failure(.invalidUserName))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                print("error 2, \(err)")
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("error 3")
                completion(.failure(.invalidResponse))
                return
            }
            //print("HTTP Response.statusCode is \(response.statusCode)")
            guard let data = data else {
                print("error 4")
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch let decodingError {
                print("error 5")
                print(decodingError)
                completion(.failure(.failedToDecode))
            }
            
        }
        
        task.resume()
    }
    
    
    func downloadImage2(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        
        if let image = cache.object(forKey: cacheKey) {  //forKey has to be unique string
            completion(image) //if the image is already downloaded, then skip the rest steps
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey) //save the downloaded image into cache
            DispatchQueue.main.async { //everytime u wnat to update the ui, u have to do it on the main thread
                completion(image)
                
            }
            
        }
        task.resume()
    }
    
    
}

