//
//  CommonUtility.swift
//  Swift Demo
//
//  Created by Pratik Gujarati on 09/08/18.
//  Copyright © 2018 Innovative Iteration. All rights reserved.
//

import UIKit

class CommonUtility: NSObject {

    override init()
    {
        super.init()
    }
    
    func isValidEmailAddress(strEmailString: String)-> Bool
    {
//        let emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: strEmailString)
    }
}
