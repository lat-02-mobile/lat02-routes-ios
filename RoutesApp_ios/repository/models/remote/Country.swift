//
//  Country.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Country: Codable, Equatable, BaseModel {
    var id: String
    var name: String
    var code: String
    var phone: String
    @ServerTimestamp
    var createAt: Timestamp?
    @ServerTimestamp
    var updateAt: Timestamp?
    var cities: [DocumentReference]
}
