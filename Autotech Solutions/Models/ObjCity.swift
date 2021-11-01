//
//  ObjCity.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 04/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjCity: NSObject
{
    var strStateID: String = ""
    var strCityID: String = ""
    var strCityName: String = ""
    
    func separateParametersForCity(dictionary :Dictionary<String, Any>)
    {
        strStateID = dictionary["stateID"] as? String ?? ""
        strCityID = dictionary["cityID"] as? String ?? ""
        strCityName = dictionary["cityName"] as? String ?? ""
    }
}
