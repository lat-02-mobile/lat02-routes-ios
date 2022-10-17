//
//  LineEntityConverterHelper.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/17/22.
//

import Foundation

class LineEntityConverterHelper {
    static let shared = LineEntityConverterHelper()

    func convertLinesToLineRoutes(lines: [LineEntity]) -> [LineRoute] {
        var finalLineRoutes = [LineRoute]()
        for line in lines {
            for route in line.routes {
                finalLineRoutes.append(LineRoute(
                    name: route.name,
                    id: route.id,
                    idLine: line.id,
                    line: line.name,
                    routePoints: route.routePoints,
                    start: route.start,
                    stops: route.stops,
                    end: route.end,
                    averageVelocity: Double(route.averageVelocity)!,
                    blackIcon: line.category.blackIcon,
                    whiteIcon: line.category.whiteIcon,
                    color: route.color
                ))
            }
        }
        return finalLineRoutes
    }
}
