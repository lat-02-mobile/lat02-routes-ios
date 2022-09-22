//
//  RouteListFilterViewController.swift
//  RoutesApp_ios
//
//  Created by user on 21/9/22.
//

import UIKit

class RouteListFilterViewController: UIViewController {

    @IBOutlet var resetButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneButton: UIButton!

    var resetFilters = false
    var selectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    @IBAction func doneAction(_ sender: Any) {
    }

    @IBAction func resetAction(_ sender: Any) {
        resetFilters = true
        tableView.reloadRows(at: [IndexPath(item: selectedIndex, section: 0)], with: .automatic)
        // Todo: Reset lines list from viewModel
    }

    func setupTable() {
        let uiNib = UINib(nibName: TransportationCategoryTableViewCell.identifier, bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: TransportationCategoryTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension RouteListFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransportationCategoryTableViewCell.identifier, for: indexPath)
            as? TransportationCategoryTableViewCell ?? TransportationCategoryTableViewCell(style: .default,
                    reuseIdentifier: TransportationCategoryTableViewCell.identifier)
        if resetFilters {
            cell.resetStyle()
            resetFilters = false
        } else {
            cell.setStyle(selectedIndex: selectedIndex, currentIndex: indexPath.row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPathList = [IndexPath]()
        if selectedIndex != -1 {
            indexPathList.append(IndexPath(item: selectedIndex, section: 0))
        }
        indexPathList.append(indexPath)
        selectedIndex = indexPath.row
        tableView.reloadRows(at: indexPathList, with: .automatic)
    }
}
