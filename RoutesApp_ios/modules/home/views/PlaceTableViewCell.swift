//
//  PlaceTableViewCell.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/6/22.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var placeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(place: Place) {
        placeNameLabel.text = place.name
    }
}
