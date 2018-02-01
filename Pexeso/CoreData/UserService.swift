//
//  UserService.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 01.02.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit
import CoreData

class UserService {
    
    static let instance = UserService()
    private init() { }
    
    let moc: NSManagedObjectContext = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        
        return delegate.persistentContainer.viewContext
    }()
    
    func addUser(name: String, surname: String, score: Int) {
        guard let mo = NSEntityDescription.insertNewObject(forEntityName: "UserMO", into: moc) as? UserMO else {
            return
        }
        
        // TODO: use here UserService.instance.newUserMOInstance()
        
        mo.name = name
        mo.surname = surname
        mo.score = Int64(score)
        
        saveContext()
    }
    
    func addUsers(count: Int) {
        for _ in 0 ..< count {
            let mo = NSEntityDescription.insertNewObject(forEntityName: "UserMO", into: moc)
        }
        
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
        let fetchRequest = NSFetchRequest<UserMO>(entityName: "UserMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try moc.execute(deleteRequest)
        } catch {
            return
        }
    }
    
    func getAllUsers() -> [UserMO] {
        return getUsersWithNames(nameFilter: nil)
    }
    
    func getUsersWithNames(nameFilter: String?) -> [UserMO] {
        let fetchRequest = NSFetchRequest<UserMO>(entityName: "UserMO")
        let scoreSort = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [scoreSort]
        if let myName = nameFilter {
            if !myName.isEmpty {
                let predicate: NSPredicate = NSPredicate(format: "name CONTAINS[cd] %@", myName) // [cd] means case-insensitive and diacritic-insensitive
                fetchRequest.predicate = predicate
            }
        }
        var users: [UserMO] = []
        do {
            users = try moc.fetch(fetchRequest)
        } catch {
            return users
        }
        
        return users
    }
    
    /// Return a new isnatnce of UserMO
    /// If we will try following code:
    ///
    /// let user: UserMO = UserMO()
    ///
    /// we will get CoreData error: Failed to call designated initializer on NSManagedObject class 'UserMO'
    func newUserMOInstance() -> UserMO {
        return UserMO.init(entity: NSEntityDescription.entity(forEntityName: "UserMO", in: moc)!, insertInto: moc)
    }
    
    /// Add new entity to database
    /// - parameters:
    ///   - entity: object that is to be aded to DB
    ///   - entityName: The name of an entity (like "UserMO")
    /// - returns: a new instance of the class for the entity named entityName.
    func addEntity<T : NSManagedObject>(entity: T, entityName: String) -> T? {
        guard let mo = NSEntityDescription.insertNewObject(forEntityName: entityName, into: moc) as? T else {
            return nil
        }
        // It is possible to check here like this way: "if mo is UserMO {}"
        
        saveContext()
        return mo
    }
    
}
