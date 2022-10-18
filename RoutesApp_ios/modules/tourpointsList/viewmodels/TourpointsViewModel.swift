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
        let currentLocale = Locale.current.languageCode
        tourpointsManager.getTourpointList { result in
            switch result {
            case.success(let list):
                self.tourpointsManager.getTourpointCategories { categories in
                    switch categories {
                    case.success(let categories):
                        self.tourpointList = list.compactMap({$0.toTourpointInfo(categories: categories,
                                                                                 isLocationEng: currentLocale != ConstantVariables.spanishLocale)})
                        self.onFinish?()
                    case.failure(let error):
                        self.onError?(error.localizedDescription)
                    }
                }
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getPointAt(index: Int) -> TourpointInfo {
        tourpointList[index]
    }
}
