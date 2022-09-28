//
//  RouteListViewController.swift
//  RoutesApp_ios
//
//  Created by adri on 8/22/22.
//

import UIKit

class RouteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var routeListTableView: UITableView!
    var routeListViewModel = RouteListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setIcon()
        routeListViewModel.getLines {
            self.routeListTableView.reloadData()
        }
        routeListTableView.register(UINib.init(nibName: ConstantVariables.routeListCell, bundle: nil),
            forCellReuseIdentifier: ConstantVariables.routeListCell)
        routeListViewModel.reloadData = routeListTableView.reloadData
    }

    override func viewWillAppear(_ animated: Bool) {
        self.routeListTableView.reloadData()
    }

    func setupNavigationBar() {
        navigationItem.title = String.localizeString(localizedString: ConstantVariables.routeTitle)
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barTintColor = UIColor(named: ConstantVariables.primaryColor)
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = String.localizeString(localizedString: ConstantVariables.search)
        searchBar.delegate = self
        routeListTableView.delegate = self
        routeListTableView.dataSource = self
    }

    func setIcon() {
        let filterIcon = UIImage(named: ConstantVariables.filterIcon)?.withRenderingMode(.alwaysOriginal)
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(showFilterPopUp))

        navigationItem.rightBarButtonItem = filterButton
    }

    @objc func showFilterPopUp() {
        let viewControllerToPresent = RouteListFilterViewController(viewModel: routeListViewModel)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeListViewModel.filteredRouteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.routeListCell,
        for: indexPath) as? RouteListTableViewCell else {
        return  UITableViewCell()
        }
        let line =  routeListViewModel.filteredRouteList[indexPath.row]
        tableViewCell.updateCellModel(routeListDetailModel: line)
        return tableViewCell
    }
}

extension RouteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        routeListViewModel.filterRouteListBy(query: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        routeListViewModel.filterRouteListBy(query: "")
    }
}
