//
//  MainRouter.swift
//  MovieApp
//
//  Created by Adam Essam on 11/08/2022.
//

import Foundation
import Alamofire

protocol MainRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String  { get }
    var parameters: Parameters?  { get }
    var encoding: ParameterEncoding { get }
    var header : HTTPHeaders {get}
}

extension MainRouter {
    func asURLRequest() throws -> URLRequest {
        let base = NetworkConstants.baseURL
        guard var url: URL = URL(string: base) else {
            throw NetworkCustomErrors.notValidURL
        }

        url.appendPathComponent(path)
        let request = try URLRequest(url: url, method: method, headers: header)
    
        return try encoding.encode(request, with: parameters)
    }
}
