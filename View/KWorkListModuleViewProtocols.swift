
//
//  KWorkListModuleViewProtocols.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation
protocol KWorkListModuleViewInput: NSObjectProtocol {
    func showNoKworksIfNeeded()
    func kworksPrepared(_ kworks: [UserKworkEntityProtocol])
    func nextKworksPageFetchingCompleted(_ success: Bool)
    func showBusy()
    func hideBusy()
    func showAlert(with error: String?)
}

protocol KWorkListModuleViewOutput {
    func postViewDidLoad()
    func fetchNextKworksPage()
    func didTapKwork(atIndex index: Int)
    func didTapCreateKwork()
    func postViewDidDisplayed()
    func fetchInitialKWorksPage()
    func prepare(categoryId: Int32, withUserID: Int)
    func prepare(statusId: Int32, withUserID: Int)
}
