//
//  KWorkListLocalStorageServiceProtocol.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation

protocol KWorkListLocalStorageServiceProtocol {
    func saveKworks(with items: [UserKWorkEntity])
    func getkWorks() -> [UserKWorkEntity]?
    func getActiveUser() -> DTUser?
}
