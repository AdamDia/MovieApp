//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Adam Essam on 12/08/2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieViewContainer: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    static let cellIdentifier = "MovieCollectionViewCell"
    
    static func nib () -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCellUI()
    }

    private func prepareCellUI() {
        movieViewContainer.contentMode = .scaleAspectFill
    }
    
        
    func setupMovieCell(moviePosterImage: String) {
        self.showUserMovieImage(imageStr: moviePosterImage, imageView: moviePosterImageView)
        
    }
    
}

