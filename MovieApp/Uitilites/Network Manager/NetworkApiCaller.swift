//
//  NetworkApiCaller.swift
//  MovieApp
//
//  Created by Adam Essam on 11/08/2022.
//

import Foundation
import Alamofire

class NetworkApiCaller {
    var isPaginating = false
    func performNetworkRequest<T: Decodable>(_ object: T.Type, router: MainRouter, pagination: Bool = false ,completion: @escaping (Result< T, MainResponseModelError>) -> Void) {
        if pagination {
            self.isPaginating = true
        }
        AF.request(router).response { result in
            let statusCode = result.response?.statusCode
            if statusCode == 200 || statusCode == 201 {
                do {
                    guard let data = result.data else { return }
//                    data.jsonToString()
                    let dataModel = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(dataModel))
                    if pagination {
                        self.isPaginating = false
                    }
                } catch {
                    completion(.failure(MainResponseModelError(message: NetworkCustomErrors.failedToConvertData.rawValue)))
                }
                
            } else {
                completion(.failure(MainResponseModelError(message: NetworkCustomErrors.networkRequestFailed.rawValue)))
            }
        }
    }
}

