//
//  ObjCar.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 05/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjCar: NSObject
{
    var strCarID: String = ""
    var strModelName: String = ""
    var strMakeName: String = ""
    var strRegistrationNumber: String = ""
    
    func separateParametersForCar(dictionary :Dictionary<String, Any>)
    {
        strCarID = "\(dictionary["carID"] ?? "")"
        strModelName = "\(dictionary["modelName"] ?? "")"
        strMakeName = "\(dictionary["makeName"] ?? "")"
        strRegistrationNumber = "\(dictionary["registrationNumber"] ?? "")"
    }
}
