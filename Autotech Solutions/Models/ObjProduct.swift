//
//  ObjProduct.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 11/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjProduct: NSObject
{
    var strProductModelID: String = ""
    var strProductImageURL: String = ""
    var strProductName: String = ""
    var strProductDescription: String = ""
    var strProductPrice: String = ""
    
    func separateParametersForProduct(dictionary :Dictionary<String, Any>)
    {
        strProductModelID = "\(dictionary["productModelID"] ?? "")"
        strProductImageURL = "\(dictionary["image"] ?? "")"
        strProductName = "\(dictionary["name"] ?? "")"
        strProductDescription = "\(dictionary["description"] ?? "")"
        strProductPrice = "\(dictionary["price"] ?? "")"
    }

}
