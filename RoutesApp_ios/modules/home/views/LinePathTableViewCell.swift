//
//  LinePathTableViewCell.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 15/9/22.
//

import UIKit

class LinePathTableViewCell: UITableViewCell {
    static let linePathCellNib = "LinePathTableViewCell"
    static let linePathCellIdentifier = "LinePathCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(line: LineRoute, distance: Double? = nil) {
        nameLabel.text = "\(line.line), \(line.name)"
        if let distance = distance {
            distanceLabel.text = distance.fixMetersResult()
            timeLabel.text = String(Int(distance / line.averageVelocity)) + "min"
        } else {
            let routeDistance = GoogleMapsHelper.shared.getTotalPolylineDistance(coordList: line.routePoints)
            distanceLabel.text = routeDistance.fixMetersResult()
            timeLabel.text = String(Int(routeDistance / (line.averageVelocity * 60))) + "min"
        }
        if line.line == "Walk" {
            categoryImageView.image = UIImage(named: line.line.lowercased())
        } else {
            ImageHelper.shared.downloadAndCacheImage(imageView: categoryImageView, urlString: line.blackIcon)
        }
    }
}
