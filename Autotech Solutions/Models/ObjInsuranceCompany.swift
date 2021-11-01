//
//  ObjInsuranceCompany.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 04/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjInsuranceCompany: NSObject
{
    var strInsuranceCompanyID: String = ""
    var strInsuranceCompanyName: String = ""
    
    func separateParametersForInsuranceCompany(dictionary :Dictionary<String, Any>)
    {
        strInsuranceCompanyID = dictionary["insuranceCompanyID"] as? String ?? ""
        strInsuranceCompanyName = dictionary["companyName"] as? String ?? ""
    }
}
