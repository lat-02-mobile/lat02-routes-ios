//
//  LinesViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 24/10/22.
//

import UIKit

class LinesViewController: RouteListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LineEditModeViewController()
        present(vc, animated: true)
    }
}
