//
//  UserTableViewCell.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 2/11/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let nibName = "UserTableViewCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var typeUserLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        typeUserLabel.text = user.type == UserType.ADMIN.rawValue ? StringResources.admin : StringResources.normal
    }
}
