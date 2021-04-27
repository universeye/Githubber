//
//  Follower.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/27.
//

import Foundation

//0.login
struct Follower: Decodable {
    let login: String
    let id: Int
    let avatarUrl: URL
}
