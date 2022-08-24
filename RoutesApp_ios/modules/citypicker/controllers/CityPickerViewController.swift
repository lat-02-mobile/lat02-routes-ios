//
//  CityPickerViewController.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import UIKit
import SVProgressHUD

class CityPickerViewController: UIViewController {

    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    var isSettingsController = true

    let viewmodel = CityPickerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setupView() {
        self.cityTableView.delegate = self
        self.cityTableView.dataSource = self
        self.citySearchBar.delegate = self
        backButtonView.layer.cornerRadius = backButtonView.bounds.size.width * 0.5

        let uiNib = UINib(nibName: ConstantVariables.cityCellNib, bundle: nil)
        self.cityTableView.register(uiNib, forCellReuseIdentifier: ConstantVariables.cityCellIdentifier)
    }

    @IBAction func goBack(_ sender: Any) {
        guard isSettingsController else { return }
        navigationController?.popViewController(animated: true)
    }
}

extension CityPickerViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTableView.dequeueReusableCell(withIdentifier: ConstantVariables.cityCellIdentifier)
        as? CityTableViewCell ?? CityTableViewCell()
        cell.selectionStyle = .none

        let city = viewmodel.cities[indexPath.row]
        self.viewmodel.getCountry(id: city.countryId) { countries in
            if let country = countries.first {
                cell.setData(city: city.name, country: country.name)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewmodel.cities[indexPath.row]
        let vc = CitySplashViewController()
        vc.city = city.name
        show(vc, sender: nil)
    }
}

extension CityPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }

        if !text.isEmpty {
            viewmodel.getCities(text: text) { cities in
                self.viewmodel.cities = cities
                self.cityTableView.reloadData()
            }
        }
    }
}
