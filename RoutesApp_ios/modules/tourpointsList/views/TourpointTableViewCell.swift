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

    func updateCellModel(tourpoint: TourpointEntity, isCurrenLocaleEsp: Bool) {
        let category = isCurrenLocaleEsp ? tourpoint.category.descriptionEsp : tourpoint.category.descriptionEng
        nameLabel.text = tourpoint.name
        categoryLabel.text = category
        addressLabel.text = tourpoint.address
    }
}
