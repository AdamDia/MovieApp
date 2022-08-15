//
//  MainRepo.swift
//  MovieApp
//
//  Created by Adam Essam on 12/08/2022.
//

import Foundation
import Alamofire
import RxSwift

protocol MainRepositryProtocol {
    func getPopularMovies(page: Int, pagination: Bool) -> Observable<MovieDataModel>
    func getTopRatedMoive(page: Int, pagination: Bool) -> Observable<MovieDataModel>
    
}


class MainRepositryClass: MainRepositryProtocol {
    let networkApi : NetworkApiCaller
    init(apiCaller: NetworkApiCaller = NetworkApiCaller()) {
        self.networkApi = apiCaller
    }
    
    func getPopularMovies(page: Int, pagination: Bool) -> Observable<MovieDataModel> {
        Observable<MovieDataModel>.create { [unowned self] popularResult -> Disposable in
            self.networkApi.performNetworkRequest(MovieDataModel.self,router: MainScreeensRouter.getPopularMovies(page: page), pagination: pagination, completion: { result in
                switch result {
                case .success(let data):
                    popularResult.onNext(data)
                case .failure(let error):
                    popularResult.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func getTopRatedMoive(page: Int, pagination: Bool) -> Observable<MovieDataModel> {
        Observable<MovieDataModel>.create { [unowned self] topRatedResult -> Disposable in
            self.networkApi.performNetworkRequest(MovieDataModel.self, router: MainScreeensRouter.getTopRatedMovies(page: page),pagination: pagination ,completion: { result in
                switch result {
                case .success(let data):
                    topRatedResult.onNext(data)
                case .failure(let error):
                    topRatedResult.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
}
