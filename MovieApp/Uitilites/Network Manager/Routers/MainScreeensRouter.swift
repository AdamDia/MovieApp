//
//  MainScreeensRouter.swift
//  MovieApp
//
//  Created by Adam Essam on 11/08/2022.
//

import Foundation
import Alamofire

enum MainScreeensRouter: MainRouter {
  
    case getTopRatedMovies(page: Int)
    case getPopularMovies(page: Int)
    case getMovieDetails(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getTopRatedMovies, .getPopularMovies, .getMovieDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getTopRatedMovies:
            return "top_rated"
        case .getPopularMovies:
            return "popular"
        case .getMovieDetails(let id):
            return "\(id)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getTopRatedMovies(let page):
            let parameters: Parameters = [
                "api_key": NetworkConstants.apiKey,
                "page": page
            ]
            return parameters
        case .getPopularMovies(let page):
            let parameters: Parameters = [
                "api_key": NetworkConstants.apiKey,
                "page": page
            ]
            return parameters
            
        case .getMovieDetails:
            let paramters: Parameters = [
                "api_key": NetworkConstants.apiKey
            ]
            return paramters
        }
    }
    
    var encoding: ParameterEncoding {
        switch self  {
        case .getTopRatedMovies, .getPopularMovies, .getMovieDetails:
            return URLEncoding.default
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .getTopRatedMovies, .getPopularMovies, .getMovieDetails:
            let header = HTTPHeaders([HTTPHeader(name: "Accept", value: "application/json")])
            return header
        }
    }
    
    
}
