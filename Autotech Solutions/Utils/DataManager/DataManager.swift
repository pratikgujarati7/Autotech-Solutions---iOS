//
//  DataManager.swift
//  TopApps
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Eric Cerney on 9/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NYAlertViewController
import CoreLocation

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

//========== SERVER URL ==========//
let ServerIP = "http://app.autotechsolutions.in/";

//========== DEVELOPMENT SERVER URL ==========//
//let ServerIP = "http://credencetech.in/autotech-solutionqa/";

let Splash_Responce = "splash";
let User_Register = "api/register";
let User_Resend_Otp = "api/resend_otp";
let User_Verify_Mobile = "api/verify_user";
let User_Update_Register_Details = "api/update_user_register_details";
let User_Get_All_Notifications = "api/get_user_all_notifications";
let User_Get_All_Address = "api/get_all_user_address_book";
let User_Add_Address = "api/add_user_address_book";
let User_Delete_Address = "api/delete_user_address_book";
let User_Logout = "api/logout";
let User_Get_Profile = "api/get_user_profile_details";

let User_Get_My_car_List = "api/get_user_register_car_list";
let User_Get_Add_car = "api/add_user_car";
let User_Book_Service = "api/add_user_car_service";
let User_Book_Bodyshop = "api/add_user_car_bodyshop";
let User_Renew_Insurance = "api/car_insurance_quote";
let User_Get_All_Amc_By_Car = "api/get_user_amc_details_by_car";
let User_Get_All_Product_By_Car = "api/get_all_products_by_carID";
let User_Inquire_Product = "api/add_product_inquiry";
let User_Inquire_Amc = "api/add_amc_inquiry";
let User_Redeem_Amc = "api/redeem_amc_coupan";
let User_Delete_Car = "api/delete_user_car";

var dataManager = DataManager()

class DataManager : NSObject , XMLParserDelegate
{
    var appDelegate: AppDelegate?
    
    var strServerMessage : String = ""
    
    var currentLocation: CLLocation!
    var currentAddress : String = ""
    
    var strAboutAppText : String = ""
    var strShareMessage : String = ""
    var strSOSNumber : String = ""
    
    var arrayAllFualType = [ObjFualType]()
    
    var arrayAllMakes = [ObjMake]()
    var arrayAllStates = [ObjState]()
    var arrayAllBranches = [ObjBranch]()
    var arrayAllInsuranceCompanies = [ObjInsuranceCompany]()

    var objLogedInUser : ObjUser = ObjUser()
    var arrayAllNotifications = [ObjNotification]()
    var arrayAllAddress = [ObjAddress]()
    
    var arrayAllMyCars = [ObjCar]()
    
    var arrayAllAMC = [ObjAMC]()
    
    var arrayAllProducts = [ObjProduct]()
    
    let reachability = Reachability()!
    
    override init()
    {
        super.init()
                
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    
    func showInternetNotConnectedError()
    {
        //METHOD 2
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = "No Internet Connection"
        alertViewController.message = "Please make sure that you are connected to the internet."
        
        // Customize appearance as desired
        alertViewController.view.tintColor = UIColor.white
        alertViewController.backgroundTapDismissalGestureEnabled = true
        alertViewController.swipeDismissalGestureEnabled = true
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
        
        alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
        alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
        alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
        alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Go to Settings",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                AppDelegate.sharedInstance().window?.topMostController()?.dismiss(animated: true, completion: nil)
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
        })
        
        alertViewController.addAction(okAction)
        
        DispatchQueue.main.async {
            AppDelegate.sharedInstance().window?.topMostController()?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showAlertViewWithTitle(title: String, detail: String)
    {
        var strTitle : String = title
        var strDetails : String = ""
        
        if title == "Server Error" && (detail == nil || detail.count <= 0)
        {
            strDetails = "Oops! Something went wrong. Please try again later."
        }
        else if title == "Server Error" && (detail != nil || detail.count > 0)
        {
            strTitle = ""
            strDetails = detail
        }
        else
        {
            strDetails = detail
        }
        
        self.appDelegate?.dismissGlobalHUD()
        
        self.appDelegate?.showAlertViewWithTitle(title: strTitle, detail: strDetails)
    }
    
    func convertStringToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary as! [String : AnyObject]? as NSDictionary?
            } catch let error as NSError {
                var errorResponse = [String : AnyObject]()
                errorResponse["Error"] = "Issue" as AnyObject?
                print(error)
                return errorResponse as NSDictionary?
            }
        }
        return nil
    }
    
    func user_session_expired()
    {
        DispatchQueue.main.async(execute: {
            
            let prefs = UserDefaults.standard
            
            prefs.removeObject(forKey: "mobile_number")
            prefs.removeObject(forKey: "user_id")
            prefs.removeObject(forKey: "first_name")
            prefs.removeObject(forKey: "last_name")
            prefs.removeObject(forKey: "email")
            prefs.removeObject(forKey: "area_id")
            prefs.removeObject(forKey: "area_name")
            prefs.removeObject(forKey: "city_id")
            prefs.removeObject(forKey: "city_name")
            prefs.removeObject(forKey: "referral_code")
            prefs.removeObject(forKey: "user_is_verified")
            prefs.removeObject(forKey: "autologin")
            prefs.removeObject(forKey: "is_already_registered")
            prefs.removeObject(forKey: "accessToken")
            
            prefs.synchronize()
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Your session hase been expired please login again to continue."
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = true
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
            
            alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
            alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
            alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
            alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
            
            alertViewController.buttonColor = MySingleton.sharedManager().themeGlobalRedColor

            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.appDelegate!.window?.rootViewController? .dismiss(animated: true, completion: nil)
                    
                    let viewController = User_LoginViewController()
                    self.appDelegate!.navigationController!.pushViewController(viewController, animated: false)
            })
            
            alertViewController.addAction(okAction)
        
            self.appDelegate!.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
            
        })
    }
    
    // MARK: - USER DATA FUNCTIONS
    
    // MARK: USER FUNCTION FOR GET SPLASH RESPONCE
    
    func user_get_splash_responce()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, Splash_Responce)
            let strImageName = String(format:".png")
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strAboutAppText = "\(jsonResult["about_us_text"] ?? "")"
                            self.strShareMessage = "\(jsonResult["shareMessage"] ?? "")"
                            self.strSOSNumber = "\(jsonResult["sos_number"] ?? "")"
                            
                            // FILL MAKE ARRAY
                            let arrayMakeRecordsLocal = jsonResult["arrMakeRecord"] as? NSArray
                            self.arrayAllMakes = [ObjMake]()
                            for objMakeTemp in arrayMakeRecordsLocal!
                            {
                                let objMakeDictionary = objMakeTemp as? NSDictionary
                                let objNewMake : ObjMake = ObjMake()
                                objNewMake.separateParametersForMake(dictionary: objMakeDictionary as! Dictionary<String, Any>)
                                self.arrayAllMakes.append(objNewMake)
                            }
                            
                            // FILL STATE ARRAY
                            let arrayStateRecordsLocal = jsonResult["arrStateRecord"] as? NSArray
                            self.arrayAllStates = [ObjState]()
                            for objStateTemp in arrayStateRecordsLocal!
                            {
                                let objStateDictionary = objStateTemp as? NSDictionary
                                let objNewState : ObjState = ObjState()
                                objNewState.separateParametersForState(dictionary: objStateDictionary as! Dictionary<String, Any>)
                                self.arrayAllStates.append(objNewState)
                            }
                            
                            // FILL BRANCH ARRAY
                            let arrayBranchRecordsLocal = jsonResult["arrBranchRecord"] as? NSArray
                            self.arrayAllBranches = [ObjBranch]()
                            for objBranchTemp in arrayBranchRecordsLocal!
                            {
                                let objBranchDictionary = objBranchTemp as? NSDictionary
                                let objNewBranch : ObjBranch = ObjBranch()
                                objNewBranch.separateParametersForBranch(dictionary: objBranchDictionary as! Dictionary<String, Any>)
                                self.arrayAllBranches.append(objNewBranch)
                            }
                            
                            // FILL INSURANCE COMPANY ARRAY
                            let arrayInsuranceCompanyRecordsLocal = jsonResult["arrInsuranceCompanyRecord"] as? NSArray
                            self.arrayAllInsuranceCompanies = [ObjInsuranceCompany]()
                            for objInsuranceCompanyTemp in arrayInsuranceCompanyRecordsLocal!
                            {
                                let objInsuranceCompanyDictionary = objInsuranceCompanyTemp as? NSDictionary
                                let objNewInsuranceCompany : ObjInsuranceCompany = ObjInsuranceCompany()
                                objNewInsuranceCompany.separateParametersForInsuranceCompany(dictionary: objInsuranceCompanyDictionary as! Dictionary<String, Any>)
                                self.arrayAllInsuranceCompanies.append(objNewInsuranceCompany)
                            }
                            
                            // FILL FUAL TYPE ARRAY
                            self.arrayAllFualType = [ObjFualType]()
                            
                            for i in 0...2
                            {
                                let objNewFualType : ObjFualType = ObjFualType()
                                if (i == 0)
                                {
                                    objNewFualType.strFualTypeID = "1"
                                    objNewFualType.strFualType = "Petrol"
                                }
                                else if (i == 1)
                                {
                                    objNewFualType.strFualTypeID = "2"
                                    objNewFualType.strFualType = "CNG"
                                }
                                else
                                {
                                    objNewFualType.strFualTypeID = "3"
                                    objNewFualType.strFualType = "Diesel"
                                }
                                self.arrayAllFualType.append(objNewFualType)
                            }
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_splash_responceEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR REGISTER
    
    func user_register(strMobile :String, deviceToken :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Register)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let parameters = ["mobileNumber" : "\(strMobile)", "deviceToken" : "\(deviceToken)", "deviceType" : "2"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            let userData: NSDictionary = data["userDetails"] as! NSDictionary
                            
                            self.strShareMessage = "\(jsonResult["shareMessage"] ?? "")"
                            
                            self.objLogedInUser = ObjUser()
                            self.objLogedInUser.separateParametersForRegister(dictionary: userData as! Dictionary<String, Any>)
                            
                            prefs.set(strMobile, forKey: "mobile_number")
                            prefs.synchronize()
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_registeredEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR RESEND OTP
    
    func user_resend_otp(strMobile :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Resend_Otp)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let parameters = ["mobileNumber" : "\(strMobile)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            self.showAlertViewWithTitle(title: "", detail: self.strServerMessage)
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_resent_otpEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR VERIFY MOBILE
    
    func user_verify_mobile(strUserId :String, strAccessToken :String, strOtp :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Verify_Mobile)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let parameters = ["userID" : "\(strUserId)", "accessToken" : "\(strAccessToken)", "otp" : "\(strOtp)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            if (data["userDetails"] != nil)
                            {
                                let userData: NSDictionary = data["userDetails"] as! NSDictionary
                                
                                //self.objLogedInUser = ObjUser()
                            self.objLogedInUser.separateParametersForAlreadyRegisteredVerifyUser(dictionary: userData as! Dictionary<String, Any>)
                                
                                prefs.set(self.objLogedInUser.strUserID, forKey: "user_id")
                                prefs.set(self.objLogedInUser.strAccessToken, forKey: "access_token")
                                prefs.set(self.objLogedInUser.strFirstName, forKey: "first_name")
                                prefs.set(self.objLogedInUser.strLastName, forKey: "last_name")
                                prefs.set(self.objLogedInUser.strEmail, forKey: "email")
                                prefs.set(self.objLogedInUser.strStateID, forKey: "state_id")
                                prefs.set(self.objLogedInUser.strStateName, forKey: "state_name")
                                prefs.set(self.objLogedInUser.strCityID, forKey: "city_id")
                                prefs.set(self.objLogedInUser.strCityName, forKey: "city_name")
                                prefs.set(self.objLogedInUser.strAreaName, forKey: "area_name")
                                prefs.set(self.objLogedInUser.strReferralCode, forKey: "referral_code")
                                
                                prefs.set("1", forKey: "user_is_verified")
                                prefs.set("1", forKey: "autologin")
                                prefs.synchronize()
                                
                            }
                            else
                            {
                                prefs.set(strUserId, forKey: "user_id")
                                prefs.set(strAccessToken, forKey: "access_token")
                                if (self.objLogedInUser.boolIsAlreadyRegistered)
                                {
                                    prefs.set("1", forKey: "is_already_registered")
                                }
                                else
                                {
                                    prefs.set("0", forKey: "is_already_registered")
                                }
                                
                                prefs.set("1", forKey: "user_is_verified")
                                prefs.set("1", forKey: "autologin")
                                prefs.synchronize()
                            }
                            
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_verified_mobileEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR VERIFY MOBILE
    
    func user_update_register_details(strFirstName :String, strLastName :String, strEmail :String, strStateID :String, strCityID :String, strArea :String, strReferralCode :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Update_Register_Details)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "firstName" : "\(strFirstName)",
                "lastName" : "\(strLastName)",
                "email" : "\(strEmail)",
                "cityID" : "\(strCityID)",
                "areaName" : "\(strArea)",
                "referralCode" : "\(strReferralCode)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            prefs.set(strFirstName, forKey: "first_name")
                            prefs.set(strLastName, forKey: "last_name")
                            prefs.set(strEmail, forKey: "email")
                            prefs.set(strStateID, forKey: "state_id")
                            //prefs.set(self.objLogedInUser.strAreaName, forKey: "area_name")
                            prefs.set(strCityID, forKey: "city_id")
                            prefs.set(strArea, forKey: "area_name")
                            //prefs.set(self.objLogedInUser.strCityName, forKey: "city_name")
                            //prefs.set(strReferralCode, forKey: "referral_code")
                            
                            prefs.synchronize()
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_updated_register_detailsEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET ALL NOTIFICATIONS
    
    func user_get_all_notification_list()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Get_All_Notifications)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)"]
            
//            let parameters = [
//                "userID" : "2",
//                "accessToken" : "DLFJVJWCRTM6E5ZEMW3E5W17CZRTHZ"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            
                            let arrayNotificationsLocal = data["userAllNotificationList"] as? NSArray
                            self.arrayAllNotifications = [ObjNotification]()
                            for objNotificationTemp in arrayNotificationsLocal!
                            {
                                let objNotificationDictionary = objNotificationTemp as? NSDictionary
                                let objNewNotification : ObjNotification = ObjNotification()
                                objNewNotification.separateParametersForNotification(dictionary: objNotificationDictionary as! Dictionary<String, Any>)
                                self.arrayAllNotifications.append(objNewNotification)
                            }
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_all_notification_listEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET ALL ADDRESS LIST
    
    func user_get_all_address_list()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Get_All_Address)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)"]
            
            //            let parameters = [
            //                "userID" : "2",
            //                "accessToken" : "DLFJVJWCRTM6E5ZEMW3E5W17CZRTHZ"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            
                            let arrayAddressLocal = data["userAddressBookList"] as? NSArray
                            self.arrayAllAddress = [ObjAddress]()
                            for objAddressTemp in arrayAddressLocal!
                            {
                                let objAddressDictionary = objAddressTemp as? NSDictionary
                                let objNewAddress : ObjAddress = ObjAddress()
                                objNewAddress.separateParametersForAddress(dictionary: objAddressDictionary as! Dictionary<String, Any>)
                                self.arrayAllAddress.append(objNewAddress)
                            }
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_all_address_listEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR ADD ADDRESS
    
    func user_add_address(strAddressTitle: String, strAddress: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Add_Address)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "title" : "\(strAddressTitle)",
                "address" : "\(strAddress)",
                "text" : ""]
            
            //            let parameters = [
            //                "userID" : "2",
            //                "accessToken" : "DLFJVJWCRTM6E5ZEMW3E5W17CZRTHZ"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_added_addressEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR DELETE ADDRESS
    
    func user_delete_address(strAddressID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Delete_Address)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "userAddressBookID" : "\(strAddressID)"]
            
            //            let parameters = [
            //                "userID" : "2",
            //                "accessToken" : "DLFJVJWCRTM6E5ZEMW3E5W17CZRTHZ"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            
                            let arrayAddressLocal = data["userAddressBookList"] as? NSArray
                            self.arrayAllAddress = [ObjAddress]()
                            for objAddressTemp in arrayAddressLocal!
                            {
                                let objAddressDictionary = objAddressTemp as? NSDictionary
                                let objNewAddress : ObjAddress = ObjAddress()
                                objNewAddress.separateParametersForAddress(dictionary: objAddressDictionary as! Dictionary<String, Any>)
                                self.arrayAllAddress.append(objNewAddress)
                            }
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_deleted_addressEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET MY CAR LIST
    
    func user_get_my_car_list()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Get_My_car_List)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            
                            let arrayMyCarsLocal = data["carDetails"] as? NSArray
                            self.arrayAllMyCars = [ObjCar]()
                            for objMyCarTemp in arrayMyCarsLocal!
                            {
                                let objMyCarDictionary = objMyCarTemp as? NSDictionary
                                let objNewCar : ObjCar = ObjCar()
                                objNewCar.separateParametersForCar(dictionary: objMyCarDictionary as! Dictionary<String, Any>)
                                self.arrayAllMyCars.append(objNewCar)
                            }
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_my_car_listEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET MY CAR LIST
    
    func user_add_car(strMakeID :String, strModelID :String, strRegistrationNumber :String, strFualTypeID :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Get_Add_car)
            let strImageName = String(format:".png")
                        
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "makeID" : "\(strMakeID)",
                "modelID" : "\(strModelID)",
                "registrationNumber" : "\(strRegistrationNumber)",
                "fuelType" : "\(strFualTypeID)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_added_carEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR BOOK A SERVICE
    
    func user_book_service(strCarID :String, strBranchID :String, strServiceDate :String, strRechability :String, strLocation :String, strPickupTime :String, strLattitude :String, strLongitude :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Book_Service)
            let strImageName = String(format:".png")
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "carID" : "\(strCarID)",
                "branchID" : "\(strBranchID)",
                "serviceDate" : "\(strServiceDate)",
                "reachability" : "\(strRechability)",
                "pickupAddress" : "\(strLocation)",
                "latitude" : "\(strLattitude)",
                "longitude" : "\(strLongitude)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_booked_serviceEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR BOOK A BODYSHOP
    
    func user_book_bodyshop(strCarID :String, strBranchID :String, strServiceDate :String, strRechability :String, strLocation :String, strPickupTime :String, strLattitude :String, strLongitude :String, arrayImages: Array<UIImage>)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Book_Bodyshop)
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "carID" : "\(strCarID)",
                "branchID" : "\(strBranchID)",
                "serviceDate" : "\(strServiceDate)",
                "reachability" : "\(strRechability)",
                "pickupAddress" : "\(strLocation)",
                "latitude" : "\(strLattitude)",
                "longitude" : "\(strLongitude)",
                "image_data_count" : "\(arrayImages.count)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                var i : Int = 0
                for image in arrayImages
                {
                    let imageData : Data = image.pngData()! as Data
                    let strImageName : String = String(format: "image_data%d", i)
                    multipartFormData.append(imageData, withName: strImageName, fileName: "\(strImageName).png", mimeType: "image/png")
                    i = i + 1
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_booked_bodyshopEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR INSURANCE RENEWAL
    
    func user_renew_insurance(strInsuranceCompanyID :String, strCarID :String, strPolicyNumber :String, strExpiryDate :String, strYearOfMenufactury :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Renew_Insurance)
            let strImageName = String(format:".png")
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "insuranceCompanyID" : "\(strInsuranceCompanyID)",
                "carID" : "\(strCarID)",
                "policyNumber" : "\(strPolicyNumber)",
                "expiryDate" : "\(strExpiryDate)",
                "yearOfManufacture" : "\(strYearOfMenufactury)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_renewed_insuranceEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET ALL AMC BY CAR
    
    func user_get_all_amc_by_car(strCarID :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Get_All_Amc_By_Car)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "carID" : "\(strCarID)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            
                            let arrayAmcLocal = data["arrAMC"] as? NSArray
                            self.arrayAllAMC = [ObjAMC]()
                            for objAmcTemp in arrayAmcLocal!
                            {
                                let objAmcDictionary = objAmcTemp as? NSDictionary
                                let objNewAmc : ObjAMC = ObjAMC()
                                objNewAmc.separateParametersForAMC(dictionary: objAmcDictionary as! Dictionary<String, Any>)
                                self.arrayAllAMC.append(objNewAmc)
                            }
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_all_amc_by_carEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            self.arrayAllAMC = [ObjAMC]()
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_all_amc_by_carEvent"), object: self)
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET ALL PRODUCTS BY CAR
    
    func user_get_all_product_by_car(strCarID :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Get_All_Product_By_Car)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "carID" : "\(strCarID)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            
                            let arrayProductsLocal = data["productsList"] as? NSArray
                            self.arrayAllProducts = [ObjProduct]()
                            for objProductTemp in arrayProductsLocal!
                            {
                                let objProductDictionary = objProductTemp as? NSDictionary
                                let objNewProduct : ObjProduct = ObjProduct()
                                objNewProduct.separateParametersForProduct(dictionary: objProductDictionary as! Dictionary<String, Any>)
                                self.arrayAllProducts.append(objNewProduct)
                            }
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_all_product_by_carEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET ALL PRODUCTS BY CAR
    
    func user_inquire_product(strCarID :String, strProductModelID :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Inquire_Product)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "carID" : "\(strCarID)",
                "productModelID" : "\(strProductModelID)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_inquired_productEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR INQUIRE AMC
    
    func user_inquire_amc(strCarID :String, strAmcID :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Inquire_Amc)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "carID" : "\(strCarID)",
                "amcID" : "\(strAmcID)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_inquired_amcEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR REDEEM AMC
    
    func user_redeem_amc(strAmcUserID :String, strAmcType :String, strAmcCouponID :String, strPin :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Redeem_Amc)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "amcUserID" : "\(strAmcUserID)",
                "amcType" : "\(strAmcType)",
                "amcCoupanID" : "\(strAmcCouponID)",
                "pin" : "\(strPin)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_redeemed_amcEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR DELETE CAR
    
    func user_delete_car(strCarID :String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Delete_Car)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)",
                "carID" : "\(strCarID)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_deleted_carEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR LOGOUT
    
    func user_logout()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Logout)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_logedoutEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: USER FUNCTION FOR GET PROFILE DETAILS
    
    func user_get_profile_details()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_Get_Profile)
            let strImageName = String(format:".png")
            
            let prefs = UserDefaults.standard
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            
            let parameters = [
                "userID" : "\(strUserID)",
                "accessToken" : "\(strAccessToken)"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(Data(), withName: "profileImage", fileName: strImageName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }, to:strUrlString)
            { (result) in
                self.appDelegate?.dismissGlobalHUD()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        print(response.result)
                        
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonResult = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            }
                            return
                        }
                        // get and print the title
                        guard let code = jsonResult["code"] as? Int else {
                            print("Could not get success from JSON")
                            self.showAlertViewWithTitle(title: "Server Error", detail: "")
                            return
                        }
                        print("success: \(code)")
                        
                        if(code == 100)
                        {
                            
                            let data: NSDictionary = jsonResult["data"] as! NSDictionary
                            let userData: NSDictionary = data["userDetails"] as! NSDictionary
                            
                            self.objLogedInUser = ObjUser()
                            self.objLogedInUser.separateParametersForGetProfileDetails(dictionary: userData as! Dictionary<String, Any>)
                            
                            //prefs.set(strMobile, forKey: "mobile_number")
                            prefs.set(self.objLogedInUser.strFirstName, forKey: "first_name")
                            prefs.set(self.objLogedInUser.strLastName, forKey: "last_name")
                            prefs.set(self.objLogedInUser.strEmail, forKey: "email")
                            prefs.set(self.objLogedInUser.strStateID, forKey: "state_id")
                            prefs.set(self.objLogedInUser.strStateName, forKey: "state_name")
                            prefs.set(self.objLogedInUser.strCityID, forKey: "city_id")
                            prefs.set(self.objLogedInUser.strCityName, forKey: "city_name")
                            prefs.set(self.objLogedInUser.strAreaName, forKey: "area_name")
                            prefs.set(self.objLogedInUser.strReferralCode, forKey: "referral_code")
                            prefs.synchronize()
                            
                            self.strServerMessage = "\(jsonResult["message"] ?? "")"
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "user_got_profile_detailsEvent"), object: self)
                        }
                        else if(code == 102)
                        {
                            // SESSION EXPIRED
                            self.user_session_expired()
                        }
                        else
                        {
                            let message = jsonResult["message"] as? String
                            self.showAlertViewWithTitle(title: "", detail: message!)
                        }
                    }
                    
                case .failure(let encodingError): break
                //print encodingError.description
                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            }
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }

}
