//
//  UserService.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 01.02.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit
import CoreData

private let entityNameScore = "ScoreMO"

class UserService {
    
    static let instance = UserService()
    private init() { }
    
    let moc: NSManagedObjectContext = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        
        return delegate.persistentContainer.viewContext
    }()
    
    func addUser(name: String, cardsPairsNumber: Int, score: Int) {
        guard let mo = NSEntityDescription.insertNewObject(forEntityName: entityNameScore, into: moc) as? ScoreMO else {
            return
        }
        
        mo.name = name
        mo.cardsPairsNumber = Int64(cardsPairsNumber)
        mo.score = Int64(score)
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try moc.save()
        } catch {
            return
        }
    }
    
    func deleteAllUsers() {
        let fetchRequest = NSFetchRequest<ScoreMO>(entityName: entityNameScore)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try moc.execute(deleteRequest)
        } catch {
            return
        }
    }
    
    func getAllUsers() -> [ScoreMO] {
        return getUsersWithNames(nameFilter: nil)
    }
    
    /// Returns an array of users containing nameFilter in the name
    func getUsersWithNames(nameFilter: String?) -> [ScoreMO] {
        let fetchRequest = NSFetchRequest<ScoreMO>(entityName: entityNameScore)
        let scoreSort = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [scoreSort]
        if let myName = nameFilter {
            if !myName.isEmpty {
                let predicate: NSPredicate = NSPredicate(format: "name CONTAINS[cd] %@", myName) // [cd] means case-insensitive and diacritic-insensitive
                fetchRequest.predicate = predicate
            }
        }
        var users: [ScoreMO] = []
        do {
            users = try moc.fetch(fetchRequest)
        } catch {
            return users
        }
        
        return users
    }
    
}
