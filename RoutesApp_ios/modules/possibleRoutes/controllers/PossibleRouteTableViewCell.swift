//
//  PossibleRouteTableViewCell.swift
//  RoutesApp_ios
//
//  Created by user on 15/9/22.
//

import UIKit

class PossibleRouteTableViewCell: UITableViewCell {

    static var identifier = "PossibleRouteTableViewCell"

    @IBOutlet var transportCategoryImage: UIImageView!
    @IBOutlet var routeLabel: UILabel!
    @IBOutlet var estimatedTimeLabel: UILabel!
    @IBOutlet var mainBackgroundView: UIView!
    @IBOutlet var recommendedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupStyle(selectedIndex: Int, currentIndex: Int) {
        recommendedLabel.text = String.localizeString(localizedString: "recommended")
        recommendedLabel.isHidden = (currentIndex != 0)
        if selectedIndex == currentIndex {
            estimatedTimeLabel.textColor = .white
            routeLabel.textColor = .white
            recommendedLabel.textColor = .white
            mainBackgroundView.backgroundColor = UIColor(named: ConstantVariables.primaryColor)
        } else {
            estimatedTimeLabel.textColor = UIColor(named: ConstantVariables.primaryColor)
            routeLabel.textColor = UIColor(named: ConstantVariables.primaryColor)
            recommendedLabel.textColor = UIColor(named: ConstantVariables.primaryColor)
            mainBackgroundView.backgroundColor = .white
        }
    }

}
