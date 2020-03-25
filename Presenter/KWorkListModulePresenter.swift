//
//  KWorkListPresenter.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation
class KWorkListModulePresenter {
    
    weak var view: KWorkListModuleViewInput?
    var interactor: KWorkListModuleInteractorInput!
    var router: KWorkListModuleRouterInput!
}

extension KWorkListModulePresenter: KWorkListModuleInteractorOutput {

    
    func kworksWasFetched(_ kworks: [UserKworkEntityProtocol]) {
        assert(view != nil)
        view?.kworksPrepared(kworks)
    }
    
    func nextKWorkdPageFetchingCompleted(_ success: Bool) {
        assert(view != nil)
        view?.nextKworksPageFetchingCompleted(success)
        
    }
    
    func kworksFetchedWithEmptyResult() {
        assert(view != nil)
        view?.showNoKworksIfNeeded()
    }
    
    func isViewBecomes(busy: Bool) {
        busy ? view?.showBusy() : view?.hideBusy()
    }
    
    func showAlert(with error: String?) {
        view?.showAlert(with: error)
    }
}

extension KWorkListModulePresenter: KWorkListModuleViewOutput {
    
    func postViewDidDisplayed() {
        
    }
    
    func fetchInitialKWorksPage() {
        interactor.fetchInitialKWorkdPage()
    }
    
    
    func postViewDidLoad() {
        interactor.fetchInitialKWorkdPage()
    }
    
    func fetchNextKworksPage() {
        interactor.fetchNextKWorksPage()
    }
    
    func didTapKwork(atIndex index: Int) {
        guard let kworkPath = interactor.kworkPath(index), let kworkTitle = interactor.kworkTitle(index) else {
            return
        }
        router.openKWorkDetailModule(kworkPath, kworkTitle)
    }
    
    func didTapCreateKwork() {
        router.openCreateKworkModule()
    }
    
    func prepare(categoryId: Int32, withUserID: Int) {
        interactor.prepare(with: withUserID)
        interactor.setCategoryID(categoryId)
//        fetchInitialKWorksPage()
    }
    
    func prepare(statusId: Int32, withUserID: Int) {
        interactor.prepare(with: withUserID)
        interactor.setStatusID(statusId)
//        fetchInitialKWorksPage()
    }
}
