//
//  LoadingMotion.swift
//  Flicko
//
//  Created by Gohar on 11/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

final class LoadingMontion: NSObject {
    
    static let sharedInstance = LoadingMontion()
    var activityIndicator:UIActivityIndicatorView?
    
    func getActivityIndicatorView() -> UIActivityIndicatorView? {
        if activityIndicator == nil {
            
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
            activityIndicator?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            activityIndicator?.hidesWhenStopped = true
            DispatchQueue.main.async {
                self.activityIndicator?.frame = (UIApplication.shared.keyWindow?.frame)!
                UIApplication.shared.keyWindow?.addSubview(self.activityIndicator!)
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.bringSubviewToFront(self.activityIndicator!)
        }
        return activityIndicator
    }
    
    func showActivityIndicator() {
        getActivityIndicatorView()?.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.getActivityIndicatorView()?.stopAnimating();
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

