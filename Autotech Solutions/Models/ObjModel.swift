//
//  ObjModel.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 05/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjModel: NSObject
{
    var strMakeID: String = ""
    var strModelID: String = ""
    var strModelName: String = ""
    
    func separateParametersForModel(dictionary :Dictionary<String, Any>)
    {
        strMakeID = dictionary["makeID"] as? String ?? ""
        strModelID = dictionary["modelID"] as? String ?? ""
        strModelName = dictionary["modelName"] as? String ?? ""
    }
}
