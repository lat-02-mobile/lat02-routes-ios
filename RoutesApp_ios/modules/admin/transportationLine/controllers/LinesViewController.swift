//
//  LinesViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 24/10/22.
//

import UIKit
import SVProgressHUD

class LinesViewController: RouteListViewController {

    let viewmodel = LinesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initViewModel() {
        SVProgressHUD.show()
        isCurrentLocaleEsp = currentLocale == ConstantVariables.spanishLocale
        viewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.lineListTableView.reloadData()
        }
        viewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        viewmodel.getCategories()
    }

    override func setIcon() {
        let filterIcon = UIImage(named: ConstantVariables.filterIcon)?.withRenderingMode(.alwaysOriginal)
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(showFilterPopUp))

        let addIcon = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let addButton = UIBarButtonItem(image: addIcon, style: .plain, target: self, action: #selector(showEditModeVC))
        navigationItem.rightBarButtonItems = [filterButton, addButton]
    }

    @objc func showEditModeVC() {
        let vc = LineEditModeViewController()
        show(vc, sender: nil)
    }
}

extension LinesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.lines.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LineEditModeViewController()
        vc.targetLine = viewmodel.lines[indexPath.row]
        show(vc, sender: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.routeListCell,
        for: indexPath) as? RouteListTableViewCell else {
        return  UITableViewCell()
        }
        let line = viewmodel.lines[indexPath.row]
        tableViewCell.routeLine.text = line.name
        guard let lineCat = viewmodel.categories.first(where: ({$0.id == line.idCategory})) else { return RouteListTableViewCell()}
        let lineCatName = isCurrentLocaleEsp ? lineCat.nameEsp : lineCat.nameEng
        tableViewCell.routeCategory.text = lineCatName
        return tableViewCell
    }
}
