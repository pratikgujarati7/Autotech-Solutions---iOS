//
//  ObjAddress.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 26/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjAddress: NSObject
{
    var strAddressID: String = ""
    var strAddressTitle: String = ""
    var strAddress: String = ""
    
    func separateParametersForAddress(dictionary :Dictionary<String, Any>)
    {
        strAddressID = "\(dictionary["userAddressBookID"] ?? "")"
        strAddressTitle = "\(dictionary["title"] ?? "")"
        strAddress = "\(dictionary["address"] ?? "")"
    }
}
