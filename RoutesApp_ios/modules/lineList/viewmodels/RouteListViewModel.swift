//
//  RouteListViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 8/23/22.
//

import Foundation

class RouteListViewModel: ViewModel {
    var lineRouteManager: LineRouteManagerProtocol = LineRouteFirebaseManager.shared
    var lineCategoryManager: LineCategoryManagerProtocol = LineCategoryFirebaseManager.shared
    var lineManager: LineManagerProtocol = LineFirebaseManager.shared

    var routeListModel: [Lines] = []
    var linesCategory: [LinesCategory] = []
    var lineRouteList: [LineRouteInfo] = []
    private var originalList = [RouteListDetailModel]()
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
        lineManager.getLinesForCurrentCity { result in
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
        lineRouteManager.getLineRoute(idLine: id) { result in
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
        lineCategoryManager.getCategories { result in
            switch result {
            case .success(let lines):
                self.linesCategory = lines
                self.originalList = self.mapRouteListDetailModel(routeListModel: self.routeListModel)
                self.filteredRouteList = self.originalList
                self.filteredByQueryRouteList = self.originalList
                self.filteredByCategoryRouteList = self.originalList
                completion()
            case .failure(let error):
                self.onError?(error.localizedDescription)
                completion()
            }
        }
    }

    func mapRouteListDetailModel(routeListModel: [Lines]) -> [RouteListDetailModel] {
        var routeListDetailModels = [RouteListDetailModel]()
        for routeListModel in routeListModel {
            let lineCategory = linesCategory.filter {$0.id == routeListModel.idCategory}.first
            guard let category = lineCategory else { continue }
            let id = routeListModel.id
            let idCity = routeListModel.idCity
            let nameList = routeListModel.name
            let lineEn = category.nameEng
            let lineEs = category.nameEsp
            let routemodel = RouteListDetailModel(id: id, idCity: idCity, name: nameList, nameEng: lineEn, nameEsp: lineEs, category: category)
            routeListDetailModels.append(routemodel)
        }
        return routeListDetailModels
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
        filteredByCategoryRouteList = filteredRouteList.filter({ $0.category.id == transportationCategory.id })
        filteredRouteList = filteredByCategoryRouteList
        reloadData?()
    }

    func resetFilteredByCategoryRouteList() {
        filteredByCategoryRouteList = originalList
        filteredRouteList = originalList
        selectedFilterIndex = -1
        reloadData?()
    }

}
