//
//  KworkListItemRow.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import UIKit

class KworkListItemRow: UIView {

    @IBOutlet weak var lblKworkTitle: UILabel!
    @IBOutlet weak var lblKworkPrice: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    static func nibName() -> String {
        print(UIScreen.main.bounds, self.frame)
        return "KworkListItemRow"
        
    }
    
    
}
