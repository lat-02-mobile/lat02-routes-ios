//
//  CoordinateTransformer.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import UIKit

class CoordinateTransformer: ValueTransformer {

    override func transformedValue(_ value: Any?) -> Any? {
        guard let coordinate = value as? NSCoordinates else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: coordinate, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let coordinate = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSCoordinates.self, from: data)
            return coordinate
        } catch {
            return nil
        }
    }

}
