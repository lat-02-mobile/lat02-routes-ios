//
//  SyncUnitHistory.swift
//  RoutesApp_ios
//
//  Created by admin on 10/20/22.
//
import Foundation
import CoreData

struct SyncUnitHistoryModel {
    let id: String
    let lastUpdated: Date

    func toEntity(context: NSManagedObjectContext) {
        let entity = SyncUnitHistory(context: context)
        entity.id = id
        entity.lastUpdated = lastUpdated
    }
}
