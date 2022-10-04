//
//  BottomSheetViewController.swift
//  RoutesApp_ios
//
//  Created by user on 16/9/22.
//

import UIKit
import GoogleMaps

protocol BottomSheetDelegate: AnyObject {
    func showSelectedRoute(selectedRoute: AvailableTransport)
}

class BottomSheetViewController: UIViewController {

    @IBOutlet var contentStackView: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var viewModel: PossibleRoutesViewModel
    var delegate: BottomSheetDelegate?

    init(viewModel: PossibleRoutesViewModel, possibleRoutes: [AvailableTransport]) {
        self.viewModel = viewModel
        self.viewModel.possibleRoutes = possibleRoutes
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    func setupTable() {
        let uiNib = UINib(nibName: PossibleRouteTableViewCell.identifier, bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: PossibleRouteTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func drawSelectedRoute() {
        guard let map = viewModel.map else { return }
        map.clear()
        let selectedRoute = viewModel.getSelectedRoute()
        guard !selectedRoute.transports.isEmpty else { return }
        fitMap(map: map, selectedRoute: selectedRoute)
    }

    private func fitMap(map: GMSMapView, selectedRoute: AvailableTransport) {
        var combinedTransportLines = [Coordinate]()

        for line in selectedRoute.transports {
            GoogleMapsHelper.shared.drawPolyline(map: map, list: line.routePoints, hexColor: line.color)
            combinedTransportLines += line.routePoints
        }
        GoogleMapsHelper.shared.fitAllMarkers(map: map, list: combinedTransportLines)
    }

    private func drawWalkPath(map: GMSMapView, firstStop: Coordinate, secondStop: Coordinate) {
        viewModel.getDirections(origin: firstStop, destination: secondStop) { path in
            GoogleMapsHelper.shared.drawDotPolyline(map: map, path: path)
        }
    }
}

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.possibleRoutes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PossibleRouteTableViewCell.identifier,
             for: indexPath) as? PossibleRouteTableViewCell ?? PossibleRouteTableViewCell(style: .value1,
              reuseIdentifier: PossibleRouteTableViewCell.identifier)
        let currentPossibleRoute = viewModel.possibleRoutes[indexPath.row]
        cell.setupStyle(selectedIndex: viewModel.possibleRoutesSelectedIndex, currentIndex: indexPath.row, possibleRoute: currentPossibleRoute)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        delegate?.showSelectedRoute(selectedRoute: viewModel.possibleRoutes[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
