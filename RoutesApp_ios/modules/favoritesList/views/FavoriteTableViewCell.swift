//
//  FavoriteTableViewCell.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/10/22.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    static let nibName = "FavoriteTableViewCell"
    static let identifier = "FavoriteTableViewCell"

    @IBOutlet weak var favoriteNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func updateCellModel(favorite: FavoriteDest) {
        favoriteNameLabel.text = favorite.name
    }
}
