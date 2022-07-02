//
//  StorageManager.swift
//  MyLists
//
//  Created by катя on 01.07.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyLists")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func fetchData(completion: (Result<[Client], Error>) -> Void)  {
        let fetchRequest = Client.fetchRequest()
        
        do {
            let clients = try viewContext.fetch(fetchRequest)
            completion(.success(clients))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Save data
    func save(_ name: String, _ cash: String, completion: (Client) -> Void) {
        let client = Client(context: viewContext)
        client.name = name
        client.cash = cash
        completion(client)
        saveContext()
    }
    
    func edit(_ client: Client, name: String, cash: String) {
        client.name = name
        client.cash = cash
        saveContext()
    }
    
    func delete(_ client: Client) {
        viewContext.delete(client)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
