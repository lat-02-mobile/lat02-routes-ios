//
//  RouteListViewController.swift
//  RoutesApp_ios
//
//  Created by adri on 8/22/22.
//

import UIKit

class RouteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var routeListTableView: UITableView!
    var routeListDetailViewModel = RouteDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setIcon()
        routeListDetailViewModel.getLines {
            self.routeListTableView.reloadData()
        }

        routeListTableView.register(UINib.init(nibName: ConstantVariables.routeListCell, bundle: nil), forCellReuseIdentifier: ConstantVariables.routeListCell)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.routeListTableView.reloadData()
    }

    func setupNavigationBar() {
        navigationItem.title = ConstantVariables.routeTitle
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barTintColor = UIColor(named: ConstantVariables.primaryColor)
        let routeListVC = RouteListViewController()
        let searchController = UISearchController(searchResultsController: routeListVC)
        navigationItem.searchController = searchController
        let colorValue = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = colorValue
        UINavigationBar.appearance().isTranslucent = false
    }

    func setIcon() {
        let filterIcon = UIImage(named: ConstantVariables.filterIcon)?.withRenderingMode(.alwaysOriginal)
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(showFilterPopUp))

        navigationItem.rightBarButtonItem = filterButton
    }

    @objc func showFilterPopUp() {

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeListDetailViewModel.routeListDetailModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.routeListCell,
        for: indexPath) as? RouteListTableViewCell else {
        return  UITableViewCell()
        }
        let line =  routeListDetailViewModel.routeListDetailModels[indexPath.row]
        tableViewCell.updateCellModel(routeListDetailModel: line)
        return tableViewCell
    }
}
