//
//  HomeVM.swift
//  MovieApp
//
//  Created by Adam Essam on 12/08/2022.
//

import Foundation
import RxSwift
import RxCocoa

struct HomePagination {
    var totalPages: Int
    var currentPage: Int
}

class HomeVM {
    private let homeRepo = MainRepositryClass()
    private let disposebag = DisposeBag()
    
    ///track current page
    private var homePagination: PublishSubject<HomePagination> = .init()
    lazy var publishedHomePagination: Observable<HomePagination> = homePagination.asObservable()
    
    
    ///all Movies data
    private var movieData: PublishSubject<[Movie]> = .init()
    lazy var publishedMovieData: Observable<[Movie]> = movieData.asObservable()
    
    
    var isLoading: BehaviorRelay<Bool> = .init(value: false)
    var errorMessage: BehaviorRelay<String> = .init(value: "")
    
    func getPopularMovie(page: Int = 1, pagination: Bool = false) {
        guard !homeRepo.networkApi.isPaginating else { return }
        isLoading.accept(true)
        homeRepo.getPopularMovies(page: page, pagination: pagination).subscribe(onNext: { [unowned self] movies in
            self.isLoading.accept(false)
            self.homePagination.onNext(HomePagination(totalPages: movies.totalPages, currentPage: movies.page))
            self.movieData.onNext(movies.results)
        }, onError: { [unowned self] error in
            self.isLoading.accept(false)
            guard let error = error as? MainResponseModelError else { return }
            self.errorMessage.accept(error.message!)
        }).disposed(by: disposebag)
    }
    
    func getTopRatedMovie(page: Int = 1, pagination: Bool = false) {
        guard !homeRepo.networkApi.isPaginating else { return }
        isLoading.accept(true)
        homeRepo.getTopRatedMoive(page: page, pagination: pagination).subscribe(onNext: { [unowned self] movies in
            self.isLoading.accept(false)
            self.homePagination.onNext(HomePagination(totalPages: movies.totalPages, currentPage: movies.page))
            self.movieData.onNext(movies.results)
        }, onError: { [unowned self] error in
            self.isLoading.accept(false)
            guard let error = error as? MainResponseModelError else { return }
            self.errorMessage.accept(error.message!)
        }).disposed(by: disposebag)
    }
    
}

