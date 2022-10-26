//
//  LineRouteEntity+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//
//

import Foundation
import CoreData

extension LineRouteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LineRouteEntity> {
        return NSFetchRequest<LineRouteEntity>(entityName: self.name)
    }

    @NSManaged public var averageVelocity: String
    @NSManaged public var color: String
    @NSManaged public var createAt: Date
    @NSManaged public var id: String
    @NSManaged public var idLine: String
    @NSManaged public var name: String
    @NSManaged public var strEnd: String
    @NSManaged public var strRoutePoints: String
    @NSManaged public var strStart: String
    @NSManaged public var strStops: String
    @NSManaged public var line: LineEntity

    public var end: Coordinate {
        get {
            return (try? JSONDecoder().decode(Coordinate.self, from: Data(strEnd.utf8))) ?? Coordinate(latitude: 0, longitude: 0)
        }
        set {
           do {
               let endData = try JSONEncoder().encode(newValue)
               strEnd = String(data: endData, encoding: .utf8) ?? ""
           } catch { strEnd = "" }
        }
    }

    public var start: Coordinate {
        get {
            return (try? JSONDecoder().decode(Coordinate.self, from: Data(strStart.utf8))) ?? Coordinate(latitude: 0, longitude: 0)
        }
        set {
           do {
               let startData = try JSONEncoder().encode(newValue)
               strStart = String(data: startData, encoding: .utf8) ?? ""
           } catch { strStart = "" }
        }
    }

    public var stops: [Coordinate] {
        get {
           return (try? JSONDecoder().decode([Coordinate].self, from: Data(strStops.utf8))) ?? []
        }
        set {
           do {
               let stopsData = try JSONEncoder().encode(newValue)
               strStops = String(data: stopsData, encoding: .utf8) ?? ""
           } catch { strStops = "" }
        }
    }

    public var routePoints: [Coordinate] {
        get {
           return (try? JSONDecoder().decode([Coordinate].self, from: Data(strRoutePoints.utf8))) ?? []
        }
        set {
           do {
               let pointsData = try JSONEncoder().encode(newValue)
               strRoutePoints = String(data: pointsData, encoding: .utf8) ?? ""
           } catch { strRoutePoints = "" }
        }
    }
}

extension LineRouteEntity: Identifiable {

}
