import UIKit
import EzPopup
import SVProgressHUD

class RouteListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lineListTableView: UITableView!
    var routeListViewModel = RouteListViewModel()
    let lineRouteViewController = LineRouteViewController()
    let currentLocale = Locale.current.languageCode
    var isCurrentLocaleEsp = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setIcon()
        initViewModel()
        lineListTableView.register(UINib.init(nibName: ConstantVariables.routeListCell,
        bundle: nil), forCellReuseIdentifier: ConstantVariables.routeListCell)
        routeListViewModel.reloadData = lineListTableView.reloadData
    }

    override func viewWillAppear(_ animated: Bool) {
        self.lineListTableView.reloadData()
    }

    func initViewModel() {
        SVProgressHUD.show()
        isCurrentLocaleEsp = currentLocale == ConstantVariables.spanishLocale
        routeListViewModel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.lineListTableView.reloadData()
        }
        routeListViewModel.onError = { _ in
            SVProgressHUD.dismiss()
        }
        routeListViewModel.getLines()
    }

    func showLineRoutes(line: LineEntity) {
        let lineRouteList = line.routes
        if lineRouteList.count > 1 {
            lineRouteViewController.lineRouteList = lineRouteList
            let screenSize: CGRect = UIScreen.main.bounds
            let width = screenSize.width - 30
            let height = screenSize.height / 4
            let popupVC = PopupViewController(contentController: lineRouteViewController, popupWidth: width, popupHeight: height)
            popupVC.cornerRadius = 10
            present(popupVC, animated: true)
        } else if lineRouteList.count == 1 {
            let linePath = lineRouteList[0]
            let routeMapViewController = RouteMapViewController()
            routeMapViewController.linePath = linePath
            present(routeMapViewController, animated: false)
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

// MARK: UITableView Delegate
extension RouteListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeListViewModel.lines.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let line = routeListViewModel.lines[indexPath.row]
        showLineRoutes(line: line)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.routeListCell,
        for: indexPath) as? RouteListTableViewCell else {
        return  UITableViewCell()
        }
        let line =  routeListViewModel.lines[indexPath.row]
        tableViewCell.updateCellModel(line: line, isCurrentLocaleEsp: isCurrentLocaleEsp)
        return tableViewCell
    }
}

// MARK: Searchbar delegate
extension RouteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        routeListViewModel.applyFilters(query: text, selectedCat: routeListViewModel.categoryAux)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        routeListViewModel.applyFilters(query: "", selectedCat: routeListViewModel.categoryAux)
    }
}
