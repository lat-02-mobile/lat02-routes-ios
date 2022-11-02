//
//  LineRoutesViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 28/10/22.
//

import Foundation

class AdminLineRouteViewModel: ViewModel {
    var lineRoutesManager: LineRouteManagerProtocol = LineRouteFirebaseManager()
    var lineRoutes = [LineRouteInfo]()
    var currIdLine: String?

    func getLineRoutes() {
        lineRoutesManager.getLineRoutesByLine(idLine: currIdLine ?? "") { result in
            switch result {
            case .success(let lineRoutes):
                self.lineRoutes = lineRoutes
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
