//
//  ObjAMC.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 09/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjAMC: NSObject
{
    var strAMCID: String = ""
    var strAMCTitle: String = ""
    var strAMCDescription: String = ""
    var strAMCType: String = ""
    var strPrice: String = ""
    var strIsPurchased: String = ""
    var strAMCUserID: String = ""
    
    var arrayAllCoupons = [ObjAMCCoupon]()
    
    func separateParametersForAMC(dictionary :Dictionary<String, Any>)
    {
        strAMCID = "\(dictionary["amcID"] ?? "")"
        strAMCTitle = "\(dictionary["amcTitle"] ?? "")"
        strAMCDescription = "\(dictionary["amcDescription"] ?? "")"
        strAMCType = "\(dictionary["amcType"] ?? "")"
        strPrice = "\(dictionary["price"] ?? "")"
        strIsPurchased = "\(dictionary["isPurchased"] ?? "")"
        strAMCUserID = "\(dictionary["amcUserID"] ?? "")"
        
        let arrayAllCouponsLocal = dictionary["amcDetails"] as? NSArray
        arrayAllCoupons = [ObjAMCCoupon]()
        for objCouponTemp in arrayAllCouponsLocal!
        {
            let objCouponDictionary = objCouponTemp as? NSDictionary
            let objNewCoupon : ObjAMCCoupon = ObjAMCCoupon()
            objNewCoupon.separateParametersForAMCCoupon(dictionary: objCouponDictionary as! Dictionary<String, Any>)
            arrayAllCoupons.append(objNewCoupon)
        }
    }

}
