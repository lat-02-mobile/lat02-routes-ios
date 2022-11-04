//
//  CityListViewController.swift
//  RoutesApp_ios
//
//  Created by user on 3/11/22.
//

import UIKit
import SVProgressHUD

class CityListViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    let viewmodel = CityViewModel()
    var country: Country

    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.country = Country(id: "", name: "", code: "", phone: "", cities: [])
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initViewModel()
        title = country.name.uppercased()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewmodel.getCities()
        searchBar.text = ""
    }

    func setupViews() {
        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self

        let addIcon = UIImage(systemName: ConstantVariables.plusIcon)?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let addButton = UIBarButtonItem(image: addIcon, style: .plain, target: self, action: #selector(showCityEditModeVC))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func showCityEditModeVC() {
        let city = Cities(country: "", id: "", idCountry: "", lat: "", lng: "", name: "")
        let vc = CityEditModeViewController(city: city)
        show(vc, sender: nil)
    }

    func initViewModel() {
        viewmodel.countryId = country.id
        SVProgressHUD.show()
        viewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.tableView.reloadData()
        }
        viewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }
    }
}

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewmodel.filterCities(text: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewmodel.filterCities(text: "")
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = viewmodel.filteredCities[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = city.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewmodel.filteredCities[indexPath.row]
        let vc = CityEditModeViewController(city: city)
        show(vc, sender: true)
    }
}
