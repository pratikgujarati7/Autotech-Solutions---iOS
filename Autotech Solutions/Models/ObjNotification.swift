//
//  ObjNotification.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 08/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjNotification: NSObject
{
    var strNotificationID: String = ""
    var strNotificationTitle: String = ""
    var strNotificationText: String = ""
    var strNotificationDate: String = ""
    
    func separateParametersForNotification(dictionary :Dictionary<String, Any>)
    {
        strNotificationID = "\(dictionary["notificationID"] ?? "")"
        strNotificationTitle = "\(dictionary["notificationTitle"] ?? "")"
        strNotificationText = "\(dictionary["notificationText"] ?? "")"
        strNotificationDate = "\(dictionary["notificationDate"] ?? "")"
    }
}
