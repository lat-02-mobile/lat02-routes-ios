//
//  LinesViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 25/10/22.
//

import Foundation

class LinesViewModel: ViewModel {
    var lineManager: LineManagerProtocol = LineFirebaseManager()
    var lineCategoryManager: LineCategoryManagerProtocol = LineCategoryFirebaseManager()
    var lines = [Lines]()
    var categories = [LinesCategory]()
    private var originalLines = [Lines]()

    var queryAux = ""
    var categoryAux: LinesCategory?

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

    func applyFilters(query: String, selectedCat: LinesCategory?) {
        filterLinesBy(query: query)
        onFinish?()
    }

    private func filterLinesBy(query: String) {
        if query.isEmpty {
            lines = originalLines
        } else {
            let normalizedQuery = query.uppercased()
            lines = originalLines.filter({ $0.name.uppercased().contains(normalizedQuery) })
        }
    }
}
