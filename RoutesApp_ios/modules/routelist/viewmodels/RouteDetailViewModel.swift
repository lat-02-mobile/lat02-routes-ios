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
    private var linesCategory : [LinesCategory] = []
    var routeListDetailModels: [RouteListDetailModel] = []
    var db = Firestore.firestore()
    
    func getLines(completion: @escaping () -> ()) {
        
        firebaseManager.getLines(type: Lines.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                self.routeListModel = lines
                self.getCategories(completion: completion)
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }

    func getCategories(completion: @escaping () -> ()) {
        firebaseManager.getLinesCategory(type: LinesCategory.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                self.linesCategory = lines
                self.mapRouteListDetailModel()
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func mapRouteListDetailModel() {
        for routeListModel in routeListModel {
            let lineCategory = linesCategory.filter{$0.id == routeListModel.idCategory}.first
            let routeListDetailModel = RouteListDetailModel(idCity: routeListModel.idCity, name: routeListModel.name, routePoints: routeListModel.routePoints, line: lineCategory?.nameEng, start: routeListModel.start, end: routeListModel.end, nameEng: lineCategory?.nameEng, nameEsp: lineCategory?.nameEsp)
            routeListDetailModels.append(routeListDetailModel)
        }
    }
}
