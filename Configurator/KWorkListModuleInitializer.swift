//
//  KWorkListInitializer.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation
class KWorkListModuleInitializer: NSObject {
    
    @IBOutlet weak var kworkList: KWorkListModuleVC!
    
    override func awakeFromNib() {
        let configurator = KWorkListModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: kworkList)
    }
}

//MARK: - ArchivedProjectsConfigurator

fileprivate class KWorkListModuleConfigurator {
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {
        if let viewController = viewInput as? KWorkListModuleVC {
            configure(viewController: viewController)
        }
    }
    
    private func configure(viewController: KWorkListModuleVC) {
        let router = KWorkListModuleRouter()
        

        let presenter = KWorkListModulePresenter()
        presenter.view = viewController
        presenter.router = router
        router.transitionHandler = viewController
        
        let networkService = ProfileNetworkService()
        let paginationService = PaginationService()
       
        let localStorageService = KWorkListLocalStorageService()
        let interactor = KWorkListModuleInteractor(networkService,
                                                   paginationService: paginationService,
                                                   localStorageService: localStorageService)
        
        interactor.output = presenter
        presenter.interactor = interactor
        
        viewController.output = presenter
        
        
    }
}

