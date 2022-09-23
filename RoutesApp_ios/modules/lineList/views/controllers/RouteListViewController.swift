import UIKit
import EzPopup
class RouteListViewController: UIViewController {

    @IBOutlet weak var lineListTableView: UITableView!
    var routeDetailViewModel = RouteDetailViewModel()
    let lineRouteViewController = LineRouteViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        lineListTableView.dataSource = self
        lineListTableView.delegate = self
        setupNavigationBar()
        setIcon()
        initViewModel()
        routeDetailViewModel.getLines {
            self.lineListTableView.reloadData()
        }
        lineListTableView.register(UINib.init(nibName: ConstantVariables.routeListCell,
        bundle: nil), forCellReuseIdentifier: ConstantVariables.routeListCell)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lineListTableView.reloadData()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func initViewModel() {
        routeDetailViewModel.fecthedLineRoute = { [weak self] () in
            guard let lineRouteList = self?.routeDetailViewModel.lineRouteList else { return }
            if lineRouteList.count > 1 {
                self?.lineRouteViewController.lineRouteList = lineRouteList
                let screenSize: CGRect = UIScreen.main.bounds
                let width = screenSize.width - 30
                let height = screenSize.height / 4
                let popupVC = PopupViewController(contentController: self!.lineRouteViewController, popupWidth: width, popupHeight: height)
                popupVC.cornerRadius = 10
                self?.present(popupVC, animated: true)
            } else if lineRouteList.count == 1 {
                let linePath = self?.routeDetailViewModel.convertToLinePath(lineRouteInfo: lineRouteList[0])
                let routeMapViewController = RouteMapViewController()
                routeMapViewController.linePath = linePath
                self?.present(routeMapViewController, animated: false)
            }
        }
    }
    func setupNavigationBar() {
        navigationItem.title = String.localizeString(localizedString: "Lines")
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
}

extension RouteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDetailViewModel.lineListDetailModel.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lineId = routeDetailViewModel.lineList[indexPath.row].id ?? ""
        routeDetailViewModel.getLineRoute(id: lineId)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.routeListCell,
        for: indexPath) as? RouteListTableViewCell else {
        return  UITableViewCell()
        }
        let line =  routeDetailViewModel.lineListDetailModel[indexPath.row]
        tableViewCell.updateCellModel(routeListDetailModel: line)
        return tableViewCell
    }
}
