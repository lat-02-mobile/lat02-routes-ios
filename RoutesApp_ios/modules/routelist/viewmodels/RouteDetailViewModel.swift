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
    private var linesCategory: [LinesCategory] = []
    var routeListDetailModels: [RouteListDetailModel] = []
    var onError: ((_ error: String) -> Void)?
    var db = Firestore.firestore()

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
            let idCity = routeListModel.idCity
            let nameList = routeListModel.name
            let lineEn = lineCategory?.nameEng
            let lineEs = lineCategory?.nameEsp
            let routemodel = RouteListDetailModel(idCity: idCity, name: nameList, line: lineEn, nameEng: lineEn, nameEsp: lineEs)
            let routeListDetailModel = routemodel
            routeListDetailModels.append(routeListDetailModel)
        }
    }
}
