//
//  ObjState.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 06/04/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjState: NSObject
{
    var strStateID: String = ""
    var strStateName: String = ""
    var arrayAllCity = [ObjCity]()
    
    func separateParametersForState(dictionary :Dictionary<String, Any>)
    {
        strStateID = dictionary["stateID"] as? String ?? ""
        strStateName = dictionary["stateName"] as? String ?? ""
        
        let arrayAllCityLocal = dictionary["arrAreaRecord"] as? NSArray
        arrayAllCity = [ObjCity]()
        for objCityTemp in arrayAllCityLocal!
        {
            let objCityDictionary = objCityTemp as? NSDictionary
            let objNewCity : ObjCity = ObjCity()
            objNewCity.separateParametersForCity(dictionary: objCityDictionary as! Dictionary<String, Any>)
            arrayAllCity.append(objNewCity)
        }
    }
}
