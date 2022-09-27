import UIKit

class LineRouteViewController: UIViewController {
    @IBOutlet weak var routeListTableView: UITableView!
    var routeDetailViewModel = RouteListViewModel()
    var lineRouteList: [LineRouteInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        routeListTableView.dataSource = self
        routeListTableView.delegate = self
        routeListTableView.register(UINib.init(nibName: ConstantVariables.lineRouteCell,
        bundle: nil), forCellReuseIdentifier: ConstantVariables.lineRouteCell)
    }
    override func viewDidAppear(_ animated: Bool) {
            routeListTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
extension LineRouteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineRouteList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.lineRouteCell)
        as? LineRouteTableViewCell ?? LineRouteTableViewCell(style: .subtitle, reuseIdentifier: ConstantVariables.lineRouteCell)
        let line = lineRouteList[indexPath.row]
        cell.updateCell(lineRouteInfo: line)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let linePath = self.routeDetailViewModel.convertToLinePath(lineRouteInfo: lineRouteList[indexPath.row])
        let routeMapViewController = RouteMapViewController()
        routeMapViewController.linePath = linePath
        show(routeMapViewController, sender: nil)
    }
}
