//
//  NetworkManager.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/27.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    
    private init () {
        
    }
    
    func getFollowers(for username: String, page: Int, completion: @escaping ([Follower]?, String?) -> (Void)) {
        let endpoint = baseURL + "\(username)/followers?per_page=30&page=\(page)"
        
        print("endpoint is \(endpoint)")
        //URL Error handling
        guard let url = URL(string: endpoint) else {
            print("error 1")
            completion(nil, "Error 1, This username created an Invalid request")
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                print("error 2")
                completion(nil, "Error 2, Unable to complete your requst, please try again later \(err)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("error 3")
                completion(nil, "Error 3, Invalid response from the server , please try again")
                return
            }
            print(response.statusCode)
            guard let data = data else {
                print("error 4")
                completion(nil, "Error 4, The data from the server recieved was invalid.")
                return
            }
            print(data)
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                print("success getting followers")
                completion(followers, nil)
            } catch let decodingError {
                print("error 5")
                completion(nil, "Error 5, The data from the server recieved was invalid.\(decodingError)")
            }
            
        }
        
        task.resume()
    }
}
