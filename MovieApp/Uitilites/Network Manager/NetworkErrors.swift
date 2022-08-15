//
//  NetworkErrors.swift
//  MovieApp
//
//  Created by Adam Essam on 11/08/2022.
//

import Foundation

enum NetworkCustomErrors: String, Error {
    case failedToConvertData  = "Failed to connect, Please try again"
    case notValidURL          = "Not valid URL check the URL again"
    case networkRequestFailed = "failed to connect, Please try again"
}

struct MainResponseModelError: Decodable,  Error {
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
