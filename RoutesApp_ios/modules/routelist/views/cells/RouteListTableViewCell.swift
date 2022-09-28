//
//  RouteListTableViewCell.swift
//  RoutesApp_ios
//
//  Created by adri on 8/22/22.
//

import UIKit
import FirebaseFirestore
import CodableFirebase

class RouteListTableViewCell: UITableViewCell {

    @IBOutlet weak var routeLine: UILabel!
    @IBOutlet weak var routeCategory: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateCellModel(routeListDetailModel: RouteListDetailModel) {
        routeCategory.text = routeListDetailModel.nameEng
        routeLine.text = routeListDetailModel.name
    }
}
