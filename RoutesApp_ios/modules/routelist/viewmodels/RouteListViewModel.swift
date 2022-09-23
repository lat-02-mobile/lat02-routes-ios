//
//  RouteListViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 8/23/22.
//

import Foundation
import FirebaseFirestore

class RouteListViewModel: ViewModel {
    var routeListManager: RouteListManagerProtocol = RouteListManager.shared

    var routeListModel: [Lines] = []
    var linesCategory: [LinesCategory] = []
    var routeListDetailModels: [RouteListDetailModel] = []
    var filteredRouteList: [RouteListDetailModel] = []
    var filteredByCategoryRouteList: [RouteListDetailModel] = []
    var filteredByQueryRouteList: [RouteListDetailModel] = []
    var db = Firestore.firestore()

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
