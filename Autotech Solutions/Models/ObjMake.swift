//
//  ObjMake.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 04/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjMake: NSObject
{
    var strMakeID: String = ""
    var strMakeName: String = ""
    var arrayAllModels = [ObjModel]()
    
    func separateParametersForMake(dictionary :Dictionary<String, Any>)
    {
        strMakeID = dictionary["makeID"] as? String ?? ""
        strMakeName = dictionary["makeName"] as? String ?? ""
        
        let arrayAllModelsLocal = dictionary["arrModelRecord"] as? NSArray
        arrayAllModels = [ObjModel]()
        for objModelTemp in arrayAllModelsLocal!
        {
            let objModelDictionary = objModelTemp as? NSDictionary
            let objNewModel : ObjModel = ObjModel()
            objNewModel.separateParametersForModel(dictionary: objModelDictionary as! Dictionary<String, Any>)
            arrayAllModels.append(objNewModel)
        }
    }
}
