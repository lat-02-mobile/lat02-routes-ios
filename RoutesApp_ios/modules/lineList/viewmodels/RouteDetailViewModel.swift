import Foundation
import FirebaseFirestore

class RouteDetailViewModel {
    let firebaseManager = FirebaseFirestoreManager.shared

    var lineList: [Lines] = []
    private var linesCategory: [LinesCategory] = []
    var lineListDetailModel: [RouteListDetailModel] = []
    var lineRouteList: [LineRouteInfo] = []
    var onError: ((_ error: String) -> Void)?
    var db = Firestore.firestore()
    var fecthedLineRoute = { () -> Void in}
    var lineFetched: Bool = false {
        didSet {
            fecthedLineRoute()
        }
    }
    func getLines(completion: @escaping () -> Void) {
        firebaseManager.getLineWithBooleanCondition(type: Lines.self, forCollection: .Lines, enable: true) { result in
            switch result {
            case .success(let lines):
                self.lineList = lines
                self.getCategories(completion: completion)
            case .failure(let error):
                self.onError?(error.localizedDescription)
                completion()
            }
        }
    }
    func getLineRoute(id: String) {
        firebaseManager.getLineRoute(type: LineRouteInfo.self, forCollection: .LineRoute, id: id) { result in
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
    func convertToLinePath(lineRouteInfo: LineRouteInfo) -> LinePath {
        let start = Coordinate(latitude: lineRouteInfo.start.latitude, longitude: lineRouteInfo.start.longitude)
        let end = Coordinate(latitude: lineRouteInfo.end.latitude, longitude: lineRouteInfo.end.longitude)
        var routePoints = [Coordinate]()
        var stops = [Coordinate]()
        for line in lineRouteInfo.routePoints {
            let coordinate = Coordinate(latitude: line.latitude, longitude: line.longitude)
            routePoints.append(coordinate)
        }
        for stop in lineRouteInfo.stops {
            let coordinate = Coordinate(latitude: stop.latitude, longitude: stop.longitude)
            stops.append(coordinate)
        }
        let linePath = LinePath(name: lineRouteInfo.name, id: lineRouteInfo.id, idLine: lineRouteInfo.id,
                                line: lineRouteInfo.line, routePoints: routePoints, start: start, end: end, stops: stops)
       return linePath
    }
    func mapRouteListDetailModel() {
        for routeListModel in lineList {
            let lineCategory = linesCategory.filter {$0.id == routeListModel.idCategory}.first
            let idCity = routeListModel.idCity
            let nameList = routeListModel.name
            let lineEn = lineCategory?.nameEng
            let lineEs = lineCategory?.nameEsp
            let routemodel = RouteListDetailModel(idCity: idCity, name: nameList, line: lineEn, nameEng: lineEn, nameEsp: lineEs)
            let routeListDetailModel = routemodel
            lineListDetailModel.append(routeListDetailModel)
        }
    }
}
