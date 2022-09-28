//
//  RouteListViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 8/23/22.
//

import Foundation

class RouteListViewModel: ViewModel {
    var routeListManager: RouteListManagerProtocol = RouteListManager.shared
    var routeListModel: [Lines] = []
    var linesCategory: [LinesCategory] = []
    var lineRouteList: [LineRouteInfo] = []
    var routeListDetailModels: [RouteListDetailModel] = []
    var filteredRouteList: [RouteListDetailModel] = []
    var filteredByCategoryRouteList: [RouteListDetailModel] = []
    var filteredByQueryRouteList: [RouteListDetailModel] = []
    var fecthedLineRoute = { () -> Void in}
       var lineFetched: Bool = false {
           didSet {
               fecthedLineRoute()
           }
       }
    var selectedFilterIndex = -1

    func getLines(completion: @escaping () -> Void) {
        routeListManager.getLines { result in
            switch result {
            case .success(let lines):
                self.routeListModel = lines
                self.getCategories(completion: completion)
            case .failure(let error):
                self.onError?(error.localizedDescription)
                completion()
            }
        }
    }
    func getLineRoute(id: String) {
        routeListManager.getLineRoute(idLine: id) { result in
            switch result {
            case .success(let lines):
                self.lineRouteList = lines
                self.lineFetched = true
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }

      }

    func getCategories(completion: @escaping () -> Void) {
        routeListManager.getCategories { result in
            switch result {
            case .success(let lines):
                self.linesCategory = lines
                self.mapRouteListDetailModel()
                self.filteredRouteList = self.routeListDetailModels
                self.filteredByQueryRouteList = self.routeListDetailModels
                self.filteredByCategoryRouteList = self.routeListDetailModels
                completion()
            case .failure(let error):
                self.onError?(error.localizedDescription)
                completion()
            }
        }
    }
    func convertToLinePath(lineRouteInfo: LineRouteInfo) -> LinePath {
           let start = Coordinate(latitude: lineRouteInfo.start.latitude, longitude: lineRouteInfo.start.longitude)
           let end = Coordinate(latitude: lineRouteInfo.end.latitude, longitude: lineRouteInfo.end.longitude)
           var routePoints = [Coordinate]()
           var stops = [Coordinate]()
           for line in lineRouteInfo.routePoints {
               let coordinate = Coordinate(latitude: line.latitude, longitude: line.longitude)
               routePoints.append(coordinate)
           }
           for stop in lineRouteInfo.stops {
               let coordinate = Coordinate(latitude: stop.latitude, longitude: stop.longitude)
               stops.append(coordinate)
           }
           let linePath = LinePath(name: lineRouteInfo.name, id: lineRouteInfo.id, idLine: lineRouteInfo.id,
                                   line: lineRouteInfo.line!, routePoints: routePoints, start: start, end: end, stops: stops)
          return linePath
       }

    func mapRouteListDetailModel() {
        for routeListModel in routeListModel {
            let lineCategory = linesCategory.filter {$0.id == routeListModel.idCategory}.first
            guard let category = lineCategory else { continue }
            let idCity = routeListModel.idCity
            let nameList = routeListModel.name
            let lineEn = category.nameEng
            let lineEs = category.nameEsp
            let routemodel = RouteListDetailModel(idCity: idCity, name: nameList, nameEng: lineEn, nameEsp: lineEs, category: category)
            routeListDetailModels.append(routemodel)
        }
    }

    func filterRouteListBy(query: String) {
        if query.isEmpty {
            filteredByQueryRouteList = filteredByCategoryRouteList
            filteredRouteList = filteredByCategoryRouteList
            reloadData?()
            return
        }

        let normalizedQuery = query.uppercased()
        filteredByQueryRouteList = filteredByCategoryRouteList.filter({ route in
            guard let routeName = route.name else { return true }
            if let routeNameEsp = route.nameEsp,
               let routeNameEng = route.nameEng {
                return routeName.uppercased().contains(normalizedQuery) ||
                    routeNameEsp.uppercased().contains(normalizedQuery) ||
                    routeNameEng.uppercased().contains(normalizedQuery)
            }
            return routeName.uppercased().contains(normalizedQuery)
        })
        filteredRouteList = filteredByQueryRouteList
        reloadData?()
    }

    func filterRouteListBy(transportationCategory: LinesCategory) {
        filteredByCategoryRouteList = routeListDetailModels.filter({ $0.category.id == transportationCategory.id })
        filteredRouteList = filteredByCategoryRouteList
        reloadData?()
    }

    func resetFilteredByCategoryRouteList() {
        filteredByCategoryRouteList = routeListDetailModels
        filteredRouteList = routeListDetailModels
        selectedFilterIndex = -1
        reloadData?()
    }

}
