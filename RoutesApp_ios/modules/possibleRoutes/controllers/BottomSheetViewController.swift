//
//  BottomSheetViewController.swift
//  RoutesApp_ios
//
//  Created by user on 16/9/22.
//

import UIKit
import GoogleMaps

class BottomSheetViewController: UIViewController {

    @IBOutlet var contentStackView: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var zoom: Float = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    func setupTable() {
        let uiNib = UINib(nibName: PossibleRouteTableViewCell.identifier, bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: PossibleRouteTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PossibleRouteTableViewCell.identifier,
             for: indexPath) as? PossibleRouteTableViewCell ?? PossibleRouteTableViewCell(style: .value1,
              reuseIdentifier: PossibleRouteTableViewCell.identifier)

        return cell
    }
}
