//
//  RouteListViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 8/23/22.
//

import Foundation
import FirebaseFirestore

class RouteDetailViewModel {
    let firebaseManager = FirebaseFirestoreManager.shared

    private var routeListModel: [Lines] = []
    var linesCategory: [LinesCategory] = []
    var routeListDetailModels: [RouteListDetailModel] = []
    var filteredRouteListDetailModels: [RouteListDetailModel] = []
    var onError: ((_ error: String) -> Void)?
    var db = Firestore.firestore()
    var reloadTable: (() -> Void)?
    var selectedFilterIndex = -1

    func getLines(completion: @escaping () -> Void) {

        firebaseManager.getLines(type: Lines.self, forCollection: .Lines) { result in
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
        firebaseManager.getLinesCategory(type: LinesCategory.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                self.linesCategory = lines
                self.mapRouteListDetailModel()
                self.filteredRouteListDetailModels = self.routeListDetailModels
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
            let routePoints = routeListModel.routePoints
            let lineEn = category.nameEng
            let lineEs = category.nameEsp
            let lineStart = routeListModel.start
            let lineEnd = routeListModel.end

            let routemodel = RouteListDetailModel(idCity: idCity, name: nameList, routePoints: routePoints,
                  line: lineEn, start: lineStart, end: lineEnd, nameEng: lineEn, nameEsp: lineEs, category: category)
            let routeListDetailModel = routemodel
            routeListDetailModels.append(routeListDetailModel)
        }
    }

    func filterRouteListBy(query: String) {
        let normalizedQuery = query.uppercased()
        filteredRouteListDetailModels = filteredRouteListDetailModels.filter({ route in
            guard let routeName = route.name else { return true }
            if let routeNameEsp = route.nameEsp,
               let routeNameEng = route.nameEng {
                return routeName.uppercased().contains(normalizedQuery) ||
                    routeNameEsp.uppercased().contains(normalizedQuery) ||
                    routeNameEng.uppercased().contains(normalizedQuery)
            }
            return routeName.uppercased().contains(normalizedQuery)
        })
        reloadTable?()
    }

    func filterRouteListBy(transportationCategory: LinesCategory) {
        filteredRouteListDetailModels = filteredRouteListDetailModels.filter({ $0.category.id == transportationCategory.id })
        reloadTable?()
    }

    func resetRouteList() {
        filteredRouteListDetailModels = routeListDetailModels
        selectedFilterIndex = -1
        reloadTable?()
    }
}
