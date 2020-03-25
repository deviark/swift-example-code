//
//  KWorkListRouterProtocol.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation
protocol KWorkListModuleRouterInput {
    func openKWorkDetailModule(_ path: String, _ title: String)
    func openCreateKworkModule()
}
