//
//  LinesViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 25/10/22.
//

import Foundation

class LinesViewModel: ViewModel {
    let lineManager: LineManagerProtocol = LineFirebaseManager()
    let lineCategoryManager: LineCategoryManagerProtocol = LineCategoryFirebaseManager()
    var lines = [Lines]()
    var categories = [LinesCategory]()
    private var originalLines = [Lines]()

    func getCategories() {
        lineCategoryManager.getCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                self.getLines()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getLines() {
        lineManager.getAllLines { result in
            switch result {
            case .success(let lines):
                self.originalLines = lines
                self.lines = lines
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
