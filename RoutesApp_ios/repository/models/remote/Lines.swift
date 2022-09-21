//
//  Line.swift
//  RoutesApp_ios
//
//  Created by admin on 9/5/22.
//

import Foundation
import CodableFirebase
import Firebase

struct RouteListDetailModel {
    let idCity: String?
    let name: String?
    let line: String?
    let nameEng: String?
    let nameEsp: String?
}

struct Lines: Codable {
    let categoryRef: DocumentReference?
    let enable: Bool?
    let id: String?
    let idCity: String?
    let idCategory: String?
    let name: String?
}

struct LinesCategory: Codable {
    let id: String?
    let nameEng: String?
    let nameEsp: String?
}
