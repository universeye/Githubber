//
//  ErrorMessage.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/27.
//

import Foundation


enum GFError:  String, Error {
    case invalidUserName = "This username created an Invalid request."
    case unableToComplete = "Unable to complete your requst, please try again later."
    case invalidResponse = "Invalid response from the server , please try again."
    case invalidData = "The data from the server recieved was invalid."
    case failedToDecode = "Decoding Falied."
}
