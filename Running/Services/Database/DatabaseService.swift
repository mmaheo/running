//
//  DatabaseService.swift
//  Running
//
//  Created by Maxime Maheo on 09/03/2022.
//

import CoreData
import HealthKit

protocol DatabaseServiceProtocol: AnyObject {
    
    // MARK: - Methods
    
    func saveIfNeeded() -> Bool
    func fetchWorkout(with uuid: UUID) -> CDWorkout?
    func save(workout: HKWorkout) -> Bool
    func eraseAllData()
}

final class DatabaseService: DatabaseServiceProtocol {
    
    // MARK: - Properties
    
    private var persistentContainer: NSPersistentContainer!
    private var context: NSManagedObjectContext!
    
    // MARK: - Lifecycle
    
    init() {
        initDatabase()
    }
    
    // MARK: - Methods
    
    func saveIfNeeded() -> Bool {
        guard context.hasChanges else { return false }
    
        do {
            try context.save()
            
            return true
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchWorkout(with uuid: UUID) -> CDWorkout? {
        let fetchRequest: NSFetchRequest<CDWorkout> = NSFetchRequest(entityName: "\(CDWorkout.self)")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CDWorkout.uuid), uuid.uuidString)
        
        guard let workouts = try? context.fetch(fetchRequest) else { return nil }
        
        return workouts.first
    }
    
    func save(workout: HKWorkout) -> Bool {
        let newWorkout = CDWorkout(context: context)
        newWorkout.uuid = workout.uuid
        
        return saveIfNeeded()
    }
    
    func eraseAllData() {
        let storeContainer = persistentContainer.persistentStoreCoordinator
        
        for store in storeContainer.persistentStores {
            guard let url = store.url else { continue }

            try? storeContainer.destroyPersistentStore(at: url,
                                                       ofType: store.type,
                                                       options: nil)
            
        }
        
        initDatabase()
    }
    
    // MARK: - Private methods
    
    private func initDatabase() {
        persistentContainer = NSPersistentContainer(name: "Running")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        
        context = persistentContainer.newBackgroundContext()
    }
}
