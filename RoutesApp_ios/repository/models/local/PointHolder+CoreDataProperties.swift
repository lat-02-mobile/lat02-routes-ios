//
//  PointHolder+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//
//

import Foundation
import CoreData

extension PointHolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointHolder> {
        return NSFetchRequest<PointHolder>(entityName: "PointHolder")
    }

    @NSManaged public var idLine: String?
    @NSManaged public var point: NSCoordinates?
    @NSManaged public var isStop: Bool
    @NSManaged public var route: LineRouteEntity?

}

extension PointHolder: Identifiable {

}
