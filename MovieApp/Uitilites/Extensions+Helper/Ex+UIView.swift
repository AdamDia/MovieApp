//
//  Ex+UIView.swift
//  MovieApp
//
//  Created by Adam Essam on 13/08/2022.
//

import UIKit
import Kingfisher

extension UIView {
     func showUserMovieImage(imageStr: String, imageView: UIImageView, placeHolderImage: String = "placeHolderMovie") {
        let urlStr = "\(NetworkConstants.imagePosterPathWithImageSize)\(imageStr)"
        let url = URL(string: urlStr)
        if  let downloadURL = url {
            let resource = ImageResource(downloadURL: downloadURL)
            imageView.kf.setImage(with: resource, placeholder: UIImage(named: placeHolderImage), options: nil, completionHandler: nil)
        } else {
            imageView.image = UIImage(named: placeHolderImage)
        }
    }
    
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
