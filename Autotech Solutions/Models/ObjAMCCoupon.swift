//
//  ObjAMCCoupon.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 06/04/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ObjAMCCoupon: NSObject
{
    var strAMCID: String = ""
    var strTermsAndConditions: String = ""
    var strAMCCouponID: String = ""
    var strTitle: String = ""
    var strSubTitle: String = ""
    var strLabourDetails: String = ""
    var strPartsDetails: String = ""
    
    func separateParametersForAMCCoupon(dictionary :Dictionary<String, Any>)
    {
        strAMCID = dictionary["amcID"] as? String ?? ""
        strTermsAndConditions = dictionary["tnc"] as? String ?? "".html2String
        strAMCCouponID = dictionary["amcCoupanID"] as? String ?? ""
        strTitle = dictionary["title"] as? String ?? ""
        strSubTitle = dictionary["subTitle"] as? String ?? ""
        
        strLabourDetails = "\(dictionary["labourDetails"] ?? "")".html2String
        strPartsDetails = "\(dictionary["partsDetails"] ?? "")".html2String
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
