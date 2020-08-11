//
//  DataController.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 11/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//
//  Code reference: iOS development, udacity

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            completion?()
            
        }
    }
}

extension DataController {
    func autoSaveViewContext(interval: TimeInterval = 30){
        guard interval > 0 else {return}
        if viewContext.hasChanges {try? viewContext.save()}
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
        
    }
}
