//
//  KWorkListLocalStorageService.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation

class KWorkListLocalStorageService: NSObject {
    
    //MARK: Class variables
    
    private var databaseManager: RTDatabaseManager? {
        return BSProject.shared()?.databaseManager
    }

    private var context: NSManagedObjectContext? {
        return databaseManager?.managedObjectContext()
    }
    
    enum FieldName {
        case id
        
        var description:String {
            switch self {
            case .id: return "id"
            }
        }
    }
    
    private func createUserIfNeeded(with user: UserKWorkEntity.WorkerEntity, context: NSManagedObjectContext) -> DTUser {
        let predicateQuery = NSPredicate(format: "\(FieldName.id.description) = %i", user.id)
        
        if let userDB = databaseManager?.findItem(DatabaseEntityName.user.description, predicate: predicateQuery, context: context)?.first as? DTUser {
            return userDB
        }
        
        let userDB = DTUser(context: context)
        userDB.id = Int32(user.id)
        userDB.username = user.name
        userDB.rating = user.rating ?? 0
        userDB.rating_count = Int32(user.ratingCount ?? 0)
        userDB.online = user.isOnline ?? false
        
        return userDB
    }
}

//MARK: - ProjectsCatalogLocalStorageServiceProtocol

extension KWorkListLocalStorageService: KWorkListLocalStorageServiceProtocol {
    
    func saveKworks(with items: [UserKWorkEntity]) {
        guard let context = self.context else { return }

        do {
            items.forEach {
                let itemDB = DTKwork(context: context)
                itemDB.id = $0.id
                itemDB.category_id = $0.categoryId ?? 0
                itemDB.category_name = $0.categoryName
                itemDB.status_id = $0.statusId ?? 0
                itemDB.status_name = $0.statusName
                itemDB.title = $0.title
                itemDB.url = $0.url
                itemDB.photo = $0.photo
                itemDB.price = $0.price ?? 0
                itemDB.is_from = $0.isFrom ?? false
                itemDB.is_best = $0.isBest ?? false
                itemDB.is_hidden = $0.isHidden ?? false
                itemDB.is_favorite = $0.isFavorite ?? false
                if let user = $0.user {
                    let userDB = createUserIfNeeded(with: user, context: context)
                    userDB.addKworksObject(itemDB)
                    itemDB.user = userDB
                }
            }
            try context.save()
        } catch {
            print("DB for table: \(DatabaseEntityName.projectOffer) was failed while perform \(#function) with error: \(error.localizedDescription)")
        }
    }
    
    func getkWorks() -> [UserKWorkEntity]? {
        let predicateQuery = NSPredicate(value: true)
        let sortQuery = "\(FieldName.id.description)"
        guard let items = databaseManager?.findItem(DatabaseEntityName.kwork.description, predicate: predicateQuery, sortField: sortQuery, desc: false) as? [DTKwork] else {
             return nil
        }
        
        var kworks: [UserKWorkEntity] = []
        items.forEach {
            let kwork = UserKWorkEntity(id: $0.id,
                                        categoryId: $0.category_id,
                                        categoryName: $0.category_name,
                                        statusId: $0.status_id,
                                        statusName: $0.status_name,
                                        title: $0.title,
                                        price: $0.price,
                                        isFrom: $0.is_from,
                                        photo: $0.photo,
                                        isBest: $0.is_best,
                                        isHidden: $0.is_hidden,
                                        isFavorite: $0.is_favorite,
                                        url: $0.url)
            kworks.append(kwork)
        }
        return kworks
    }
    
    func getActiveUser() -> DTUser? {
        let userID = KWGroupUserDefaultsManager.activeUserId()
        let predicateQuery = NSPredicate(format: "\(FieldName.id)=%d", userID)
        guard let items = databaseManager?.findItem(DatabaseEntityName.user.description, predicate: predicateQuery) as? [DTUser] else { return nil }
        return items.first
    }
}
