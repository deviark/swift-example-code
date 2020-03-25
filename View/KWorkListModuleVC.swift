//
//  KWorkListModuleVC.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import UIKit
import SkeletonView

class KWorkListModuleVC: ADKTableViewViewController, ViperTransitionHandlerProtocol {

    private typealias KWorkListModuleNextPageLoadCompletionClosure = ((_ result: Bool) ->Void)
    
    //MARK: - Class variables
    var output: KWorkListModuleViewOutput?
    private var tableNode: ASTableNode! {
        get {
            return super.tableNode()
        }
    }
    
    private var kworks:[UserKworkEntityProtocol]? {
        didSet {
            reloadTableView()
        }
    }
    
    private var nextPageLoadedClosure: KWorkListModuleNextPageLoadCompletionClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "kworkslist_grey")
        tableNode.backgroundColor = UIColor(named: "kworkslist_grey")
        output?.postViewDidLoad()

    }
    
    func tryToDisplayData() {
        if viewDisplaying() {
            output?.postViewDidDisplayed()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.viewDisplaying() {
                    strongSelf.tableNode.view.tableFooterView = UIView()
                    strongSelf.output?.fetchInitialKWorksPage()
                }
            }
        }
    }
    
    private func viewDisplaying() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let info = sender as? SegueInfo else {return}
        info.configurationBlock(segue.destination as! ViperTransitionHandlerProtocol)
    }
    
    
    //MARK: - User actions
    @IBAction func btnCreateKworkTapped(_ sender: Any) {
        output?.didTapCreateKwork()
    }
    

}

//MARK: -- ADKTableViewViewControllerDelegate

extension KWorkListModuleVC {
    
    override func tableRows(_ type: TABLEROWSTYPE) -> [Any]! {
        return kworks ?? []
    }
    
    override func retrieveNextPage(completion: ((Bool) -> Void)!) {
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = .gray
            activityIndicator.frame = CGRect(x: 0,
                                             y: 0,
                                             width: UIScreen.main.bounds.width,
                                             height: 44)
            activityIndicator.startAnimating()
            self.tableNode.view.tableFooterView = activityIndicator
            self.nextPageLoadedClosure = completion
            self.output?.fetchNextKworksPage()
        }
    }
    
    override func tableNode(_ tableView: ASTableNode!, viewControllerForRowAt indexPath: IndexPath!) -> UIViewController! {
        
        guard let kworks = kworks, indexPath.item < kworks.count else {
            return UIViewController()
        }
        
        let viewController = UIViewController(nibName: KworkListItemRow.nibName(), bundle: nil)
        let cellView = viewController.view as! KworkListItemRow
        let imageFetchingClosure: (String?) -> UIImage = { [weak self] imagePath in
            
            let defaultImage = UIImage(named: "imgKWorkPlaceholder")!
            
            guard let self = self, imagePath != nil else {
                return defaultImage
            }
            
            
            return self.getImageFromLink(imagePath,
                                         user_id: 0,
                                         placeholder: defaultImage,
                                         path: indexPath,
                                         folderId: 0)
        }
        
        KworkListItemRowConfigurator.configure(view: cellView,
                                               using: kworks[indexPath.row],
                                               closureForImage: imageFetchingClosure)
        return viewController
    }
    
    override func tableNode(_ tableNode: ASTableNode!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        return 112
    }
}


extension KWorkListModuleVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didTapKwork(atIndex: indexPath.row)
    }
}

extension KWorkListModuleVC: KWorkListModuleViewInput {
    func showNoKworksIfNeeded() {
        
    }
    
    func kworksPrepared(_ kworks: [UserKworkEntityProtocol]) {
        self.kworks = kworks
    }
    
    func nextKworksPageFetchingCompleted(_ success: Bool) {
        tableNode.view.tableFooterView = UIView()
        nextPageLoadedClosure?(success)
    }
    
    func showBusy() {
        showBusyView()
    }
    
    func hideBusy() {
        hideBusyView()
    }
    
    func showAlert(with error: String?) {
        guard let error = error else { return }
        
        let alertController = UIAlertController(title: NSLocalizedString("alert.title.error", comment: ""), message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("message.alert.button.close", comment: ""), style: .cancel) { action in }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
