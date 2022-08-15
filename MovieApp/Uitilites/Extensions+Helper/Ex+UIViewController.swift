//
//  Ex+UIViewController.swift
//  MovieApp
//
//  Created by Adam Essam on 12/08/2022.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    
    //LOADING INDICATOR
    func showIndicator(withTitle title: String = "", and Description:String = "") {
       let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
       Indicator.label.text = title
       Indicator.isUserInteractionEnabled = false
       Indicator.detailsLabel.text = Description
       Indicator.show(animated: true)
    }
    
    func hideIndicator() {
       MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func addAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
