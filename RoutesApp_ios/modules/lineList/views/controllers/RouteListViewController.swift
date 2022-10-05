import UIKit
import EzPopup
class RouteListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lineListTableView: UITableView!

    var routeDetailViewModel = RouteListViewModel()
    let lineRouteViewController = LineRouteViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setIcon()
        initViewModel()
        routeDetailViewModel.getLines {
            self.lineListTableView.reloadData()
        }
        lineListTableView.register(UINib.init(nibName: ConstantVariables.routeListCell,
        bundle: nil), forCellReuseIdentifier: ConstantVariables.routeListCell)
        routeDetailViewModel.reloadData = lineListTableView.reloadData
    }

    override func viewWillAppear(_ animated: Bool) {
        self.lineListTableView.reloadData()
    }

    func initViewModel() {
        routeDetailViewModel.fecthedLineRoute = { [weak self] in
            guard let strongSelf = self else {return}
            let lineRouteList = strongSelf.routeDetailViewModel.lineRouteList
            if lineRouteList.count > 1 {
                strongSelf.lineRouteViewController.lineRouteList = lineRouteList
                let screenSize: CGRect = UIScreen.main.bounds
                let width = screenSize.width - 30
                let height = screenSize.height / 4
                let popupVC = PopupViewController(contentController: strongSelf.lineRouteViewController, popupWidth: width, popupHeight: height)
                popupVC.cornerRadius = 10
                strongSelf.present(popupVC, animated: true)
            } else if lineRouteList.count == 1 {
                let linePath = lineRouteList[0].convertToLinePath()
                let routeMapViewController = RouteMapViewController()
                routeMapViewController.linePath = linePath
                strongSelf.present(routeMapViewController, animated: false)
            }
        }
    }
    func setupNavigationBar() {
        navigationItem.title = String.localizeString(localizedString: ConstantVariables.routeTitle)
        lineListTableView.dataSource = self
        lineListTableView.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = String.localizeString(localizedString: ConstantVariables.search)
        searchBar.delegate = self
    }

    func setIcon() {
        let filterIcon = UIImage(named: ConstantVariables.filterIcon)?.withRenderingMode(.alwaysOriginal)
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(showFilterPopUp))
        navigationItem.rightBarButtonItem = filterButton
    }

    @objc func showFilterPopUp() {
        let viewControllerToPresent = RouteListFilterViewController(viewModel: routeDetailViewModel)
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
        return routeDetailViewModel.filteredRouteList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lineId = routeDetailViewModel.filteredRouteList[indexPath.row].id ?? ""
        routeDetailViewModel.getLineRoute(id: lineId)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.routeListCell,
        for: indexPath) as? RouteListTableViewCell else {
        return  UITableViewCell()
        }
        let line =  routeDetailViewModel.filteredRouteList[indexPath.row]
        tableViewCell.updateCellModel(routeListDetailModel: line)
        return tableViewCell
    }
}

extension RouteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        routeDetailViewModel.filterRouteListBy(query: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        routeDetailViewModel.filterRouteListBy(query: "")
    }
}
