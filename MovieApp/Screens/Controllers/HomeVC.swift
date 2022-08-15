//
//  HomeVC.swift
//  MovieApp
//
//  Created by Adam Essam on 12/08/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum MoviesTitleEnum : String {
    case popularMovies = "Popular Movies"
    case topRatedMovies = "Top Rated Movies"
}

class HomeVC: UIViewController  {
    
    let HomeViewModel = HomeVM()
    var currentPage: Int?
    var totalPages: Int?
    let homeDisposeBag = DisposeBag()
    let collectionCells: BehaviorRelay<[Movie]> = BehaviorRelay<[Movie]>(value: [])
    
    
    @IBOutlet weak var moviesHomeTitle: UILabel!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var settingsViewContainer: UIView!
    @IBOutlet weak var topRatedMoviesBtn: UIButton!
    @IBOutlet weak var popularMoviesBtn: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var scrollToTopViewContainer: UIView!
    
    @IBOutlet weak var scrollTopBtn: UIButton!
    @IBAction func scrollTopBtnPressed(_ sender: Any) {
        moviesCollectionView.setContentOffset(.zero, animated: true)
    }
    
    @IBAction func topRatedMoviesBtnPressed(_ sender: Any) {
        
        collectionCells.accept([])
        currentPage = 0
        self.HomeViewModel.getTopRatedMovie()
        settingsViewContainer.alpha = 0.0
        moviesHomeTitle.text = MoviesTitleEnum.topRatedMovies.rawValue
        
    }
    
    @IBAction func popularMoviesBtnPressed(_ sender: Any) {
        
        collectionCells.accept([])
        currentPage = 0
        self.HomeViewModel.getPopularMovie()
        settingsViewContainer.alpha = 0.0
        moviesHomeTitle.text = MoviesTitleEnum.popularMovies.rawValue
    }
    
    
    @IBOutlet weak var closeSettingsBtn: UIButton!
    @IBAction func closeSettingsBtnPressed(_ sender: Any) {
        closeSettingsView()
    }
    
    private func closeSettingsView() {
        UIView.animate(withDuration: 0.3) {
            self.settingsViewContainer.alpha = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setupMoviesCollection()
        subscribeToLoading()
        HomeViewModel.getPopularMovie()
        listenMoviesData()
        subscribeToPagination()
        subscribeToMoviesData()
        subscribeToErrorMessage()
    }
    
    private func prepareUI() {
        settingsBtn.setTitle("", for: .normal)
        scrollTopBtn.setTitle("", for: .normal)
        settingsBtn.setTitleColor(.white, for: .normal)
        topRatedMoviesBtn.setTitle("Top Rated", for: .normal)
        topRatedMoviesBtn.setTitleColor(.white, for: .normal)
        topRatedMoviesBtn.layer.cornerRadius = 10
        popularMoviesBtn.setTitle("Popular", for: .normal)
        popularMoviesBtn.setTitleColor(.white, for: .normal)
        popularMoviesBtn.layer.cornerRadius = 10
        closeSettingsBtn.setTitle("", for: .normal)
        moviesHomeTitle.text = MoviesTitleEnum.popularMovies.rawValue
        settingsViewContainer.layer.cornerRadius = 20
        settingsViewContainer.alpha = 0.0
        scrollToTopViewContainer.makeRounded()
    }
    
    private func setupMoviesCollection() {
        moviesCollectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.cellIdentifier)
        let layout = moviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        let width = (self.view.frame.size.width - 20) / 3
        let height = width * 1.5
        layout.itemSize = CGSize(width: width, height: height)
    }
        
    private func listenMoviesData() {
        HomeViewModel.publishedMovieData.subscribe(onNext: { [weak self] movieData in
            if let collectionCellsData = self?.collectionCells.value {
                var moviesData = collectionCellsData
                moviesData.append(contentsOf: movieData)
                self?.collectionCells.accept(moviesData)
            } else  {
                self?.collectionCells.accept(movieData)
            }
        }).disposed(by: homeDisposeBag)
    }
    
    
    
    private func subscribeToMoviesData() {
        self.collectionCells.bind(to: self.moviesCollectionView.rx.items(cellIdentifier: MovieCollectionViewCell.cellIdentifier, cellType: MovieCollectionViewCell.self)) { [weak self] (item , data , cell) in
            cell.setupMovieCell(moviePosterImage: data.posterPath)
            self?.settingsViewContainer.alpha = 0.0
        }.disposed(by: homeDisposeBag)
        
        moviesCollectionView.rx.modelSelected(Movie.self).subscribe { [weak self] item in
            let movie = item.map({$0}).element
            guard let movie = movie else { return }
            let sb =  UIStoryboard(name: "Main", bundle: nil)
            let movieDetailsVC = sb.instantiateViewController(withIdentifier: MovieDetailsVC.identifier) as! MovieDetailsVC
            movieDetailsVC.movieModel = movie
            self?.navigationController?.pushViewController(movieDetailsVC, animated: true)
        }.disposed(by: homeDisposeBag)
        
        moviesCollectionView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            guard let currentPage = self.currentPage else { return }
            guard let totalPages = self.totalPages else { return }
            
            
            let offSetY = self.moviesCollectionView.contentOffset.y
            let contentHeight = self.moviesCollectionView.contentSize.height
            let collectionHeight = self.moviesCollectionView.frame.size.height
            
            if offSetY > (contentHeight - self.moviesCollectionView.frame.size.height ) {
                if currentPage != 0 {
                    if self.moviesHomeTitle.text == MoviesTitleEnum.popularMovies.rawValue {
                        if totalPages > currentPage + 1 {
                            self.HomeViewModel.getPopularMovie(page: currentPage + 1, pagination: true)
                        }
                    } else if self.moviesHomeTitle.text == MoviesTitleEnum.topRatedMovies.rawValue {
                        if totalPages > currentPage + 1 {
                            self.HomeViewModel.getTopRatedMovie(page: currentPage + 1, pagination: true)
                            
                        }
                    }
                }
                
            }
            
            if offSetY > collectionHeight - 100 {
                self.scrollToTopViewContainer.alpha = 1.0
            } else {
                self.scrollToTopViewContainer.alpha = 0.0
            }
            
        }
        .disposed(by: homeDisposeBag)
    }
    
    private func subscribeToLoading() {
        HomeViewModel.isLoading.subscribe(onNext: { [unowned self] isLoading in
            if isLoading {
                self.blurView.isHidden = false
                self.showIndicator()
            } else {
                self.blurView.isHidden = true
                self.hideIndicator()
            }
        }).disposed(by: homeDisposeBag)
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.settingsViewContainer.alpha = 1.0
        }
        if moviesHomeTitle.text == MoviesTitleEnum.popularMovies.rawValue {
            popularMoviesBtn.isEnabled = false
            topRatedMoviesBtn.isEnabled = true
        } else {
            popularMoviesBtn.isEnabled = true
            topRatedMoviesBtn.isEnabled = false
        }
    }

    private func subscribeToPagination() {
        HomeViewModel.publishedHomePagination.subscribe(onNext: { [weak self] pagination in
            self?.currentPage = pagination.currentPage
            self?.totalPages = pagination.totalPages
            
        }).disposed(by: homeDisposeBag)
    }
    
    
        private func subscribeToErrorMessage() {
            HomeViewModel.errorMessage.subscribe(onNext: { [unowned self] erorrMessage in
                if erorrMessage != "" {
                    self.addAlert(title: erorrMessage, message: "")
                }
            }).disposed(by: homeDisposeBag)
        }
    
    
}

