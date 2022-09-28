//
//  Double.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 26/9/22.
//

import Foundation

extension Double {
    func fixMetersResult() -> String {
        if self >= 1000 {
            let kmResult = String(format: "%.2f", self.fromMetersToKm())
            return ConstantVariables.valueWithUnit(unit: .kilometers, value: kmResult)
        }
        return ConstantVariables.valueWithUnit(unit: .meters, value: (String(Int(self.rounded()))))
    }
    func fromMetersToKm() -> Double {
        return self/1000
    }
}
