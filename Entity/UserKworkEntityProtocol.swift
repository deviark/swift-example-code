//
//  UserKworkEntityProtocol.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation

protocol UserKworkEntityProtocol {
    var categoryId: Int32? { get }
    var categoryName: String? { get }
    var statusId: Int32? { get }
    var statusName: String? { get }
    var title: String? { get }
    var price: Int32? { get }
    var isFrom: Bool? { get }
    var photo: String? { get }
    var isBest: Bool? { get }
    var isHidden: Bool? { get }
    var isFavorite: Bool? { get }
    var url: String? { get }
}
