//
//  KWorkListRouter.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation
class KWorkListModuleRouter: KWorkListModuleRouterInput {
    
     private enum Segues: String {
        case toKworkDetailModule = "KWorksListModule to KworkDetailModule"
        case toCreateKworkModule = "KWorksListModule to CreateKworkModule"
    }
        
    //MARK: - Class variables
    weak var transitionHandler: ViperTransitionHandlerProtocol?
    
    
    func openKWorkDetailModule(_ path: String, _ title: String) {
        assert(transitionHandler != nil)
        transitionHandler?.openModule(with: Segues.toKworkDetailModule.rawValue) { (target) in
            let webViewVC = target as! ViperWebViewVC
            webViewVC.urlString = path
            webViewVC.title = title
            webViewVC.backBtnBlock = {
//                webViewVC.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func openCreateKworkModule() {
           assert(transitionHandler != nil)
           transitionHandler?.openModule(with: Segues.toCreateKworkModule.rawValue) { (target) in
               let webViewVC = target as! ViperWebViewVC
               webViewVC.urlString = WEBSITE_SUBDOMAIN_BASE + "/new"
               webViewVC.title = NSLocalizedString("profile.createKwork.title", comment: "")
               webViewVC.backBtnBlock = {
//                   webViewVC.navigationController?.popViewController(animated: true)
               }
           }
       }
}
