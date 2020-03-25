//
//  KWorkListInteractorProtocol.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation
protocol KWorkListModuleInteractorInput {
    func fetchInitialKWorkdPage()
    func fetchNextKWorksPage()
    func kworkPath(_ index: Int) -> String?
    func kworkTitle(_ index: Int) -> String?
    func prepare(with userId: Int)
    func setCategoryID(_ categoryID: Int32)
    func setStatusID(_ statusID: Int32)
}

protocol KWorkListModuleInteractorOutput: class {
    func kworksWasFetched(_ kworks: [UserKworkEntityProtocol])
    func nextKWorkdPageFetchingCompleted(_ success: Bool)
    func kworksFetchedWithEmptyResult()
    func isViewBecomes(busy: Bool)
    func showAlert(with error: String?)
}
