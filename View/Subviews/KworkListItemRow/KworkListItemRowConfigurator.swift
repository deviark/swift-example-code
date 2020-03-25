//
//  KworkListItemRowConfigurator.swift
//  KworkMessenger
//
//  Created by Serbin Taras on 28.02.2020.
//  Copyright © 2020 Kwork. All rights reserved.
//

import Foundation

class KworkListItemRowConfigurator {

    typealias KworkListItemRowImageClosure = (String?) -> UIImage
    
    static func configure(view: KworkListItemRow,
                          using entityData: UserKworkEntityProtocol,
                          closureForImage: KworkListItemRowImageClosure) {
        
        view.lblKworkTitle.text = entityData.title
        if let price = entityData.price {
            view.lblKworkPrice.attributedText = priceToString(price: Int(price), isFrom: entityData.isFrom ?? false)
        }
        if let imagePath = entityData.photo, let imageUrl = URL(string: imagePath) {
            
            view.imgView.image = closureForImage(imageUrl.path)
        }
    }
        
    private static func priceToString(price: Int, isFrom: Bool) -> NSAttributedString {
        let attributed = NSMutableAttributedString()
        let fromString = NSLocalizedString("exchange.projects.from_cost", comment: "")
        var  priceString = "\(price) ₽"
        
        if isFrom {
            priceString = fromString + " " + priceString
        }
        attributed
            .system(priceString, size: 14.0, weight: .bold, color: #colorLiteral(red: 0.2117647059, green: 0.6745098039, blue: 0.231372549, alpha: 1))
        
        return attributed
    }
    
}

