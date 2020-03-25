//
//  UserKworkEntity.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation

class UserKWorkEntity: Decodable, UserKworkEntityProtocol {
    let id: Int32
    
    var user: WorkerEntity? = nil
    private (set) var categoryId: Int32?
    private (set) var categoryName: String?
    private (set) var statusId: Int32?
    private (set) var statusName: String?
    private (set) var title: String?
    private (set) var price: Int32?
    private (set) var isFrom: Bool?
    private (set) var photo: String?
    private (set) var isBest: Bool?
    private (set) var isHidden: Bool?
    private (set) var isFavorite: Bool?
    private (set) var url: String?
    
    init(id:Int32,
         categoryId: Int32?,
         categoryName: String?,
         statusId: Int32?,
         statusName: String?,
         title: String?,
         price: Int32?,
         isFrom: Bool?,
         photo: String?,
         isBest: Bool?,
         isHidden: Bool?,
         isFavorite: Bool?,
         url: String?) {
        
        self.id = id
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.statusId = statusId
        self.statusName = statusName
        self.title = title
        self.photo = photo
        self.price = price
        self.isFrom = isFrom
        self.isBest = isBest
        self.isHidden = isHidden
        self.isFavorite = isFavorite
        self.url = url
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case statusId = "status_id"
        case statusName = "status_name"
        case title = "title"
        case price = "price"
        case isFrom = "is_price_from"
        case photo = "image_url"
        case isBest = "is_best"
        case isHidden = "is_hidden"
        case isFavorite = "is_favorite"
        case url = "url"
        case user = "worker"
    }
    
    class WorkerEntity: Decodable {
        let id: Int
        let name: String?
        let rating: Double?
        let reviewsCount: Int?
        let ratingCount: Int?
        let isOnline: Bool?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "username"
            case rating = "rating"
            case reviewsCount = "reviews_count"
            case ratingCount = "rating_count"
            case isOnline = "is_online"
        }
    }
}
