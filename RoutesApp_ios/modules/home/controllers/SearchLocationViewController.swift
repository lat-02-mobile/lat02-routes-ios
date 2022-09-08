//
//  SearchLocationViewController.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/5/22.
//

import UIKit
import SVProgressHUD
import CoreLocation
import GooglePlaces

protocol SearchLocationDelegate: AnyObject {
    func onPlaceTap(location: CLLocationCoordinate2D)
}

class SearchLocationViewController: UIViewController {

    let placeBias: GMSPlaceLocationBias!
    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!

    var delegate: SearchLocationDelegate?

    private let viewModel = SearchLocationViewModel()

    init(placeBias: GMSPlaceLocationBias) {
        self.placeBias = placeBias
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setUpViews()
    }

    private func setUpViews() {
        placesTableView.delegate = self
        placesTableView.dataSource = self
        let nib = UINib(nibName: ConstantVariables.placeCellNib, bundle: nil)
        placesTableView.register(nib, forCellReuseIdentifier: ConstantVariables.placeCellIdentifier)

        placeSearchBar.delegate = self
    }

    private func initViewModel() {
        viewModel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.placesTableView.reloadData()
        }
        viewModel.onError = { _ in
            SVProgressHUD.dismiss()
        }
    }

    private func getPlaces() {
        SVProgressHUD.show()
        viewModel.fetchPlaces(query: "", placeBias: placeBias)
    }

}

// MARK: Table View Delegate
extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.placesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstantVariables.placeCellIdentifier, for: indexPath)
            as? PlaceTableViewCell else { return UITableViewCell() }
        let place = viewModel.getPlaceAt(index: indexPath.row)
        cell.setData(place: place)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = viewModel.getPlaceAt(index: indexPath.row)
        viewModel.getPlaceCoordinatesByPlaceId(place.identifier) { location in
            self.delegate?.onPlaceTap(location: location)
            self.dismiss(animated: true)
        }
    }
}

// MARK: SearchBar delegate
extension SearchLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        SVProgressHUD.show()
        if text.isEmpty {
            viewModel.fetchPlaces(query: "", placeBias: placeBias)
        } else {
            viewModel.fetchPlaces(query: text, placeBias: placeBias)
        }
    }
}
