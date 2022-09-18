//
//  CityTableViewCell.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(city: String, country: String) {
        cityNameLabel.text = city
        countryNameLabel.text = country
    }

}
