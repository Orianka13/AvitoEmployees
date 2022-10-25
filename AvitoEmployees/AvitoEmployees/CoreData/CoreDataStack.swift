//
//  CoreDataStack.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 25.10.2022.
//

import Foundation
import CoreData

final class CoreDataStack {
     
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AvitoEmployees")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func remove(employee: Employee, completion: @escaping () -> Void) {
        self.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Employee.uid)) = %@", employee.uid.uuidString)
            if let object = try? context.fetch(fetchRequest).first {
                context.delete(object)
                do {
                    try context.save()
                    DispatchQueue.main.async { completion() }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func update(employee: Employee) {
        self.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Employee.uid)) = %@", employee.uid.uuidString)
            if let object = try? context.fetch(fetchRequest).first {
                object.name = employee.name
                object.phoneNumber = employee.phoneNumber
                object.skills = employee.skills
            }
            try? context.save()
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

