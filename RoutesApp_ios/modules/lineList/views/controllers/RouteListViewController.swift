import UIKit
import EzPopup
class RouteListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lineListTableView: UITableView!
    var routeListViewModel = RouteListViewModel()
    let lineRouteViewController = LineRouteViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setIcon()
        initViewModel()
        routeListViewModel.getLines {
            self.lineListTableView.reloadData()
        }
        lineListTableView.register(UINib.init(nibName: ConstantVariables.routeListCell,
        bundle: nil), forCellReuseIdentifier: ConstantVariables.routeListCell)
        routeListViewModel.reloadData = lineListTableView.reloadData
    }

    override func viewWillAppear(_ animated: Bool) {
        self.lineListTableView.reloadData()
    }

    func initViewModel() {
        routeListViewModel.fecthedLineRoute = { [weak self] () in
            guard let lineRouteList = self?.routeListViewModel.lineRouteList else { return }
            if lineRouteList.count > 1 {
                self?.lineRouteViewController.lineRouteList = lineRouteList
                let screenSize: CGRect = UIScreen.main.bounds
                let width = screenSize.width - 30
                let height = screenSize.height / 4
                let popupVC = PopupViewController(contentController: self!.lineRouteViewController, popupWidth: width, popupHeight: height)
                popupVC.cornerRadius = 10
                self?.present(popupVC, animated: true)
            } else if lineRouteList.count == 1 {
                let linePath = self?.routeListViewModel.convertToLinePath(lineRouteInfo: lineRouteList[0])
                let routeMapViewController = RouteMapViewController()
                routeMapViewController.linePath = linePath
                self?.present(routeMapViewController, animated: false)
            }
        }
    }
    func setupNavigationBar() {
        navigationItem.title = String.localizeString(localizedString: ConstantVariables.routeTitle)
        lineListTableView.dataSource = self
        lineListTableView.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = String.localizeString(localizedString: StringResources.search)
        searchBar.delegate = self
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
}

extension RouteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeListViewModel.filteredRouteList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lineId = routeListViewModel.routeListModel[indexPath.row].id ?? ""
        routeListViewModel.getLineRoute(id: lineId)
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
