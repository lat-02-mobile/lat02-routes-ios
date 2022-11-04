//
//  CountryListViewController.swift
//  RoutesApp_ios
//
//  Created by user on 2/11/22.
//

import UIKit
import SVProgressHUD

class CountryListViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    let viewmodel = CountryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initViewModel()
        title = String.localizeString(localizedString: StringResources.countryListTitle)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewmodel.getCountries()
        searchBar.text = ""
    }

    func setupViews() {
        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
    }

    func initViewModel() {
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

extension CountryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewmodel.filterCountry(text: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewmodel.filterCountry(text: "")
    }
}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = viewmodel.filteredCountries[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = country.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = viewmodel.filteredCountries[indexPath.row]
        let vc = CityListViewController(country: country)
        show(vc, sender: true)
    }
}
