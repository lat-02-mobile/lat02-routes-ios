//
//  AdminLineRouteViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 28/10/22.
//

import Foundation
import UIKit

class AdminLineRouteViewController: LineRouteViewController {
    let viewmodel = AdminLineRouteViewModel()
    var line: Lines?
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupViews()
        title = String.localizeString(localizedString: StringResources.adminLineRoutesTitle)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        viewmodel.getLineRoutes()
    }

    func initViewModel() {
        viewmodel.currIdLine = line?.id
        viewmodel.onFinish = { [weak self] in
            self?.routeListTableView.reloadData()
        }
        viewmodel.getLineRoutes()
    }

    func setupViews() {
        let addIcon = UIImage(systemName: ConstantVariables.plusIcon)?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let addButton = UIBarButtonItem(image: addIcon, style: .plain, target: self, action: #selector(showEditModeVC))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func showEditModeVC() {
        guard let currLine = line else {return}
        let vc = LineRouteEditModeViewController(line: currLine)
        show(vc, sender: nil)
    }
}

// Table View
extension AdminLineRouteViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.lineRoutes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.lineRouteCell)
            as? LineRouteTableViewCell ?? LineRouteTableViewCell(style: .subtitle, reuseIdentifier: ConstantVariables.lineRouteCell)
        let route = viewmodel.lineRoutes[indexPath.row]
        cell.routeNameLabel.text = route.name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let mapEditorAction = UIAlertAction(title: String.localizeString(localizedString: StringResources.adminLineRoutesGoMapEditor),
                                            style: .default) { _ in
            let vc = RoutesMapEditorViewController(currentLinePath: self.viewmodel.lineRoutes[indexPath.row])
            self.show(vc, sender: nil)
        }

        let detailAction = UIAlertAction(title: String.localizeString(localizedString: StringResources.adminLineRoutesSeeDetails),
                                         style: .default) { _ in
            guard let currLine = self.line else {return}
            let vc = LineRouteEditModeViewController(line: currLine, targetLineRoute: self.viewmodel.lineRoutes[indexPath.row])
            self.show(vc, sender: nil)
        }

        let cancelAction = UIAlertAction(title: String.localizeString(localizedString: StringResources.cancel), style: .cancel) { _ in
            actionSheet.dismiss(animated: true)
        }

        actionSheet.addAction(mapEditorAction)
        actionSheet.addAction(detailAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
