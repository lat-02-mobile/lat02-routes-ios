//
//  TourpointsViewModel.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/28/22.
//

import Foundation

class TourpointsViewModel: ViewModel {
    var tourpointsManager: TourpointsManagerProtocol = TourpointsManager.shared

    private var tourpointList = [TourpointInfo]()
    var pointsCount: Int {
        tourpointList.count
    }

    func getTourpoints() {
        tourpointsManager.getTourpointList { result in
            switch result {
            case.success(let list):
                self.tourpointList = list
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getPointAt(index: Int) -> TourpointInfo {
        tourpointList[index]
    }
}
