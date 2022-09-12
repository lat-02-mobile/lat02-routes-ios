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
    @IBOutlet weak var latLongitudeDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateCellModel(routeListDetailModel: RouteListDetailModel) {
        routeCategory.text = routeListDetailModel.nameEng
        routeLine.text = routeListDetailModel.name
        let lat = routeListDetailModel.start?.latitude
        let lon = routeListDetailModel.start?.longitude
        latLongitudeDescription.text = "\(Double(round(1000*(lat ?? 0))/1000)), \(Double(round(1000*(lon ?? 0))/1000))"
    }
}
