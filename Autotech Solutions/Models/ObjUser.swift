//
//  ObjUser.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 04/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjUser: NSObject
{
    var strUserID: String = ""
    var strAccessToken: String = ""
    var boolIsAlreadyRegistered: Bool = false
    
    var strFirstName: String = ""
    var strLastName: String = ""
    var strEmail: String = ""
    var strStateID: String = ""
    var strStateName: String = ""
    var strCityID: String = ""
    var strCityName: String = ""
    var strAreaName: String = ""
    var strReferralCode: String = ""
    
    func separateParametersForRegister(dictionary :Dictionary<String, Any>)
    {
        strUserID = "\(dictionary["userID"] ?? "")"
        strAccessToken = dictionary["accessToken"] as? String ?? ""
        
        let str : String = "\(dictionary["isUserAlreadyRegistered"] ?? "0")"
        if (Int(str) == 1)
        {
            boolIsAlreadyRegistered = true
        }
        else
        {
            boolIsAlreadyRegistered = false
        }
    }
    
    func separateParametersForAlreadyRegisteredVerifyUser(dictionary :Dictionary<String, Any>)
    {
        strUserID = dictionary["userID"] as? String ?? ""
        strAccessToken = dictionary["accessToken"] as? String ?? ""
        //boolIsAlreadyRegistered = dictionary["isUserAlreadyRegistered"] as? Bool ?? false
        
        strFirstName = dictionary["firstName"] as? String ?? ""
        strLastName = dictionary["lastName"] as? String ?? ""
        strEmail = dictionary["email"] as? String ?? ""
        strStateID = dictionary["stateID"] as? String ?? ""
        strStateName = dictionary["stateName"] as? String ?? ""
        strCityID = dictionary["cityID"] as? String ?? ""
        strCityName = dictionary["cityName"] as? String ?? ""
        strAreaName = dictionary["areaName"] as? String ?? ""
        strReferralCode = dictionary["referralCode"] as? String ?? ""
    }
    
    func separateParametersForGetProfileDetails(dictionary :Dictionary<String, Any>)
    {
        //strUserID = dictionary["userID"] as? String ?? ""
        //strAccessToken = dictionary["accessToken"] as? String ?? ""
        //boolIsAlreadyRegistered = dictionary["isUserAlreadyRegistered"] as? Bool ?? false
        
        strFirstName = dictionary["firstName"] as? String ?? ""
        strLastName = dictionary["lastName"] as? String ?? ""
        strEmail = dictionary["email"] as? String ?? ""
        strStateID = dictionary["stateID"] as? String ?? ""
        strStateName = dictionary["stateName"] as? String ?? ""
        strCityID = dictionary["cityID"] as? String ?? ""
        strCityName = dictionary["cityName"] as? String ?? ""
        strAreaName = dictionary["areaName"] as? String ?? ""
        strReferralCode = dictionary["referralCode"] as? String ?? ""
    }
    
}
