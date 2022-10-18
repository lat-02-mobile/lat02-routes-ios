//
//  TourpointTableViewCell.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/27/22.
//

import UIKit

class TourpointTableViewCell: UITableViewCell {

    static let nibName = "TourpointTableViewCell"
    static let identifier = "TourpointTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateCellModel(tourpointInfo: TourpointInfo) {
        nameLabel.text = tourpointInfo.name
        categoryLabel.text = tourpointInfo.category
        addressLabel.text = tourpointInfo.address
    }
}
