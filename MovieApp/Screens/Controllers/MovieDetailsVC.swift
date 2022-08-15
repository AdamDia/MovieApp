//
//  MovieDetailsVC.swift
//  MovieApp
//
//  Created by Adam Essam on 13/08/2022.
//

import UIKit

class MovieDetailsVC: UIViewController {

    @IBOutlet weak var topMainViewContainer: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var overViewTitleLabel: UILabel!
    
    @IBOutlet weak var overviewViewContainer: UIView!
    @IBOutlet weak var titleMovieRateViewContainer: UIView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateTitleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    static let identifier = "MovieDetailsVC"
    var movieModel: Movie?

    @IBOutlet weak var backBtnViewContainer: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        setMovieDetailsModel()
    }
    
    
    private func configureVC() {
        overViewTitleLabel.text = "Overview"
        releaseDateTitleLabel.text = "Release Date"
        backBtn.setTitle("", for: .normal)
        movieTitle.textColor = .white
        movieRate.textColor = .white
        backBtnViewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        backBtnViewContainer.layer.cornerRadius = 10
        titleMovieRateViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        titleMovieRateViewContainer.layer.cornerRadius = 20
        overviewViewContainer.layer.cornerRadius = 20
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setMovieDetailsModel() {
        guard let movie = movieModel else { return }
        self.view.showUserMovieImage(imageStr: movie.posterPath, imageView: movieImageView)
        movieTitle.text = movie.title
        movieRate.text = "\(movie.voteAverage)"
        overviewLabel.text = movie.overview
        releaseDate.text = movie.releaseDate
    }
 
    
}

extension MovieDetailsVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
}
