//
//  TourPointFilterViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/11/22.
//

import UIKit

class TourPointFilterViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!

    var viewModel: TourpointsViewModel
    let currentLocale = Locale.current.languageCode
    var isCurrentLocaleEsp = false

    init(viewModel: TourpointsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        viewModel = TourpointsViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    @IBAction func resetAction(_ sender: Any) {
        viewModel.resetFilteredByCategoryRouteList()
        tableView.reloadData()
    }

    @IBAction func doneAction(_ sender: Any) {
        if viewModel.categoryAux != nil {
            viewModel.applyFilters(query: viewModel.queryAux, selectedCat: viewModel.categoryAux)
        }
    }

    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        let uiNib = UINib(nibName: TransportationCategoryTableViewCell.identifier, bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: TransportationCategoryTableViewCell.identifier)

        isCurrentLocaleEsp = currentLocale == ConstantVariables.spanishLocale
    }
}

extension TourPointFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransportationCategoryTableViewCell.identifier, for: indexPath)
            as? TransportationCategoryTableViewCell ?? TransportationCategoryTableViewCell(style: .default,
                    reuseIdentifier: TransportationCategoryTableViewCell.identifier)
        let category = viewModel.categories[indexPath.row]
        cell.setStyleForTourPoint(isSameCategory: category.id == viewModel.categoryAux?.id,
                                  tourPointCategory: category,
                                  isCurrentLocaleEsp: isCurrentLocaleEsp)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.categoryAux = viewModel.categories[indexPath.row]
        tableView.reloadData()
    }
}
