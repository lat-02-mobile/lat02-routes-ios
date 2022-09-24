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
    override func awakeFromNib() {
        super.awakeFromNib()
        distanceLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(line: LineRoute) {
        categoryImageView.image = UIImage(named: line.line.lowercased())
        nameLabel.text = "\(line.line), \(line.name)"
        if line.line == "Walk" {
            distanceLabel.text = "100m"
            distanceLabel.isHidden = false
        }
    }
}
