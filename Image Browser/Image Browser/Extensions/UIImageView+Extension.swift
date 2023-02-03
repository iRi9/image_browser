//
//  UIImageView+Extension.swift
//  Image Browser
//
//  Created by Giri Bahari on 03/02/23.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadThumbnail(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }

        Service.shared.downloadImage(url: url) { [weak self] data, error  in
            guard let self = self else { return }

            if error == nil {
                guard let dataImg = data else { return }

                guard let imageToCache = UIImage(data: dataImg) else { return }

                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.image = UIImage(data: dataImg)
            } else {
                self.image = UIImage(named: "tmdb")
            }

        }
    }
}
