//
//  BaseModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/8/22.
//

import Foundation

protocol BaseModel {
    var id: String { get set }
    var createdAt: Date { get }
}
