//
//  KWorkListInteractor.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation
class KWorkListModuleInteractor {
    //MARK: - Class Variables
    
    weak var output: KWorkListModuleInteractorOutput?
    private var paginationService: PaginationService!
    private var networkService: ProfileNetworkService!
    private var localStorageService: KWorkListLocalStorageServiceProtocol!
    private var kworks: [UserKWorkEntity] = [UserKWorkEntity]()
    private var userID:Int = 0
    private var categoryID: Int32? = nil
    private var statusID: Int32?  = nil
    private init() {
        //Not impl
    }
    
    convenience init(_ networkService: ProfileNetworkService,
                     paginationService: PaginationService,
                     localStorageService: KWorkListLocalStorageServiceProtocol) {
        self.init()
        
        self.paginationService = paginationService
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    private func fetchData(isInitial: Bool = true) {
        if isInitial {
            guard kworks.isEmpty else { return }
        }
        
        let requestData = ProfileNetworkServiceData.UserKworks(userId: Int32(userID),
                                                               categoryId: categoryID,
                                                               statusId: statusID,
                                                               page: paginationService.page)
        
        let data = ProfileNetworkServiceData(with: requestData)
        networkService.fetchData(for: .userKworks, according: data) { response in
            DispatchQueue.main.async {
                guard let response = response,
                    let data = response.data as? ProfileNetworkServiceResponse.Kworks,
                    data.success, let kworks = data.kworks else {
                        self.output?.kworksFetchedWithEmptyResult()
                        return
                }
                
                
                self.paginationService.update(with: data.paging)
                
                guard self.paginationService.wasFetched else {
                    self.kworks = kworks
                    self.localStorageService.saveKworks(with: self.kworks)
                    self.output?.kworksWasFetched(kworks)
                    self.output?.nextKWorkdPageFetchingCompleted(self.paginationService.isCatalogHasReachedTheEnd)
                    return
                }
                
                self.kworks.append(contentsOf: kworks)
                self.localStorageService.saveKworks(with: self.kworks)
                self.output?.kworksWasFetched(self.kworks)
                
                self.output?.nextKWorkdPageFetchingCompleted(self.paginationService.isCatalogHasReachedTheEnd)
                
            }
        }
    }
    
    private func fetchProjectsFromLocalStorage() {
        guard let items = self.localStorageService.getkWorks() else { return }
        self.kworks = items
        self.output?.kworksWasFetched(self.kworks)
    }
}

extension KWorkListModuleInteractor: KWorkListModuleInteractorInput {
    func prepare(with userID: Int) {
        self.userID = userID
    }
    
    func setCategoryID(_ categoryID: Int32) {
        self.categoryID = categoryID
    }
    
    func setStatusID(_ statusID: Int32) {
        self.statusID = statusID
    }
    
    func fetchInitialKWorkdPage() {
        assert(Thread.isMainThread)
        fetchData()
    }
    
    func fetchNextKWorksPage() {
        assert(Thread.isMainThread)
        
        self.paginationService.nextPage()
        
        guard !self.paginationService.isCatalogHasReachedTheEnd else {
            self.output?.nextKWorkdPageFetchingCompleted(true)
            return
        }
        
        fetchData(isInitial: false)
    }
    
    
    
    func kworkPath(_ index: Int) -> String? {
        assert(Thread.isMainThread)
        guard index < kworks.count else {
            return nil
        }
        
        let kwork = kworks[index]
        guard let url = kwork.url else {
            return nil
        }
        
        return KWGroupUserDefaultsManager.websiteSubdomain()  + "\(url)"
    }
    
    func kworkTitle(_ index: Int) -> String? {
        assert(Thread.isMainThread)
        guard index < kworks.count else {
            return nil
        }
        
        let kwork = kworks[index]
        return kwork.title
    }
}
