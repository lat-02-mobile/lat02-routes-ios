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

    func imageWith(name: String?, backgroundColor: UIColor = ColorConstants.routePointColor) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = backgroundColor
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.text = name
        nameLabel.layer.cornerRadius = nameLabel.frame.width / 2
        nameLabel.clipsToBounds = true

        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
}
