//
//  StringExtension.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 8/8/22.
//

import Foundation

extension String {
    static func localizeString(localizedString: String) -> String {
        return NSLocalizedString(localizedString, comment: "")
    }
}
