//
//  ObjBranch.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 04/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjBranch: NSObject
{
    var strBranchID: String = ""
    var strCityID: String = ""
    var strBranchName: String = ""
    
    func separateParametersForBranch(dictionary :Dictionary<String, Any>)
    {
        strBranchID = dictionary["branchID"] as? String ?? ""
        strCityID = dictionary["cityID"] as? String ?? ""
        strBranchName = dictionary["branchName"] as? String ?? ""
    }
}
