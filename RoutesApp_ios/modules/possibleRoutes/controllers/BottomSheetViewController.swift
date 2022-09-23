//
//  BottomSheetViewController.swift
//  RoutesApp_ios
//
//  Created by user on 16/9/22.
//

import UIKit
import GoogleMaps

class BottomSheetViewController: UIViewController {

    @IBOutlet var contentStackView: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var viewModel: PossibleRoutesViewModel

    init(viewModel: PossibleRoutesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadPossibleRoutes()
    }

    func setupTable() {
        let uiNib = UINib(nibName: PossibleRouteTableViewCell.identifier, bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: PossibleRouteTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func loadPossibleRoutes() {
        viewModel.getPossibleRoutes { possibleRoutes in
            self.viewModel.possibleRoutes = possibleRoutes
            self.tableView.reloadData()
        }
    }

    private func drawSelectedRoute() {
        guard let map = viewModel.map else { return }
        map.clear()
        let selectedRoute = viewModel.getSelectedRoute()
        guard !selectedRoute.transports.isEmpty else { return }
        fitMap(map: map, selectedRoute: selectedRoute)
        drawMarkers(map: map, selectedRoute: selectedRoute)
    }

    private func fitMap(map: GMSMapView, selectedRoute: AvailableTransport) {
        var combinedTransportLines = [Coordinate]()

        for line in selectedRoute.transports {
            GoogleMapsHelper.shared.drawPolyline(map: map, list: line.routePoints, hexColor: line.color)
            combinedTransportLines += line.routePoints
        }
        GoogleMapsHelper.shared.fitAllMarkers(map: map, list: combinedTransportLines)
    }

    private func drawMarkers(map: GMSMapView, selectedRoute: AvailableTransport) {
        guard let firstLine = selectedRoute.transports.first,
           let first = firstLine.routePoints.first else { return }

        GoogleMapsHelper.shared.addCustomMarker(map: map, position: first, icon: UIImage(named: ConstantVariables.originMarkerName))

        guard let lastLine = selectedRoute.transports.last,
            let last = lastLine.routePoints.last else { return }

        GoogleMapsHelper.shared.addCustomMarker(map: map, position: last, icon: UIImage(named: ConstantVariables.destinationMarkerName))

        guard selectedRoute.transports.count > 1 else { return }

        guard let firstStop = firstLine.stops.last,
              let secondStop = lastLine.stops.first else { return }

        GoogleMapsHelper.shared.addCustomMarker(map: map, position: firstStop,
            icon: UIImage(named: ConstantVariables.stopMarkerName))
        GoogleMapsHelper.shared.addCustomMarker(map: map, position: secondStop,
            icon: UIImage(named: ConstantVariables.stopMarkerName))

        drawWalkPath(map: map, firstStop: firstStop, secondStop: secondStop)
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
        var indexPathList = [IndexPath]()
        if viewModel.possibleRoutesSelectedIndex != -1 {
            indexPathList.append(IndexPath(row: viewModel.possibleRoutesSelectedIndex, section: 0))
        }
        indexPathList.append(indexPath)
        viewModel.possibleRoutesSelectedIndex = indexPath.row
        self.tableView.reloadRows(at: indexPathList, with: .fade)
        drawSelectedRoute()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
