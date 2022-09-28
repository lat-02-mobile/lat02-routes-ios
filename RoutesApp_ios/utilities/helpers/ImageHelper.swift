//
//  ImageHelper.swift
//  RoutesApp_ios
//
//  Created by user on 22/9/22.
//

import Foundation
import Kingfisher

class ImageHelper {
    static var shared = ImageHelper()

    func downloadAndCacheImage(imageView: UIImageView, urlString: String) {
        let imageProcessor = DownsamplingImageProcessor(size: imageView.frame.size)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: urlString),
            options: [
                .processor(imageProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
    }
}
