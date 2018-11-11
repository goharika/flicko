//
//  ImageCollectionViewCell.swift
//  Flicko
//
//  Created by Gohar on 10/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var galleryImageView: UIImageView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPhotoCellWith(photo: Photo) {
        DispatchQueue.main.async {
            if let url = photo.mediaURL {
                self.galleryImageView?.sd_setImage(with: URL(string: url), completed:{ (image, error, cacheType, imageURL) in
                    
                    /*
                     completed get Image from serverURL, Perform Show Animation.
                     */
                   // showAnimationFunction()
                })
                    //.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                
            }
        }
    }

}
