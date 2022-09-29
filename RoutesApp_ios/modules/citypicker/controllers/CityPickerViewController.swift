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
        initViewModel()
        getCities()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setupView() {
        let placeholder = (String.localizeString(localizedString: ConstantVariables.search))
        self.citySearchBar.searchTextField.backgroundColor = UIColor .white
        self.citySearchBar.barTintColor = UIColor .clear
        self.citySearchBar.backgroundImage = UIImage()
        self.citySearchBar.placeholder = placeholder
        backButtonView.layer.cornerRadius = backButtonView.bounds.size.width * 0.5

        self.cityTableView.delegate = self
        self.cityTableView.dataSource = self
        self.citySearchBar.delegate = self

        let uiNib = UINib(nibName: ConstantVariables.cityCellNib, bundle: nil)
        self.cityTableView.register(uiNib, forCellReuseIdentifier: ConstantVariables.cityCellIdentifier)
    }

    func initViewModel() {
        viewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.cityTableView.reloadData()
        }
        viewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }
    }

    func getCities() {
        SVProgressHUD.show()
        viewmodel.getCities()
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
        self.viewmodel.getCountry(id: city.idCountry) { countries in
            if let country = countries.first {
                cell.setData(city: city.name, country: country.name)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewmodel.cities[indexPath.row]
        let vc = CitySplashViewController()
        vc.idCity = city.id
        vc.city = city.name
        vc.cityId = city.id
        vc.cityLat = city.lat
        vc.cityLng = city.lng
        show(vc, sender: nil)
    }
}

extension CityPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if !text.isEmpty {
            SVProgressHUD.show()
            viewmodel.getCitiesByName(text: text)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            self.viewmodel.cities = self.viewmodel.citiesOriginalList
            self.cityTableView.reloadData()
        } else {
            viewmodel.filterCity(text: text)
            self.cityTableView.reloadData()
        }
    }
}
