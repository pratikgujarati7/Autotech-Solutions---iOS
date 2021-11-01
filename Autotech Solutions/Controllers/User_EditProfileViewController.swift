//
//  User_EditProfileViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 05/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_EditProfileViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //MENU
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    
    @IBOutlet var txtFirstNameContainerView: UIView?
    @IBOutlet var imageViewFirstName: UIImageView?
    @IBOutlet var lblFirstName: UILabel?
    @IBOutlet var txtFirstName: UITextField?
    @IBOutlet var txtFirstNameBottomSeparatorView: UIView?
    
    @IBOutlet var txtLastNameContainerView: UIView?
    @IBOutlet var imageViewLastName: UIImageView?
    @IBOutlet var lblLastName: UILabel?
    @IBOutlet var txtLastName: UITextField?
    @IBOutlet var txtLastNameBottomSeparatorView: UIView?
    
    @IBOutlet var txtEmailContainerView: UIView?
    @IBOutlet var imageViewEmail: UIImageView?
    @IBOutlet var lblEmail: UILabel?
    @IBOutlet var txtEmail: UITextField?
    @IBOutlet var txtEmailBottomSeparatorView: UIView?
    
    @IBOutlet var txtStateContainerView: UIView?
    @IBOutlet var imageViewState: UIImageView?
    @IBOutlet var lblState: UILabel?
    @IBOutlet var txtState: UITextField?
    @IBOutlet var txtStateBottomSeparatorView: UIView?
    
    @IBOutlet var txtCityContainerView: UIView?
    @IBOutlet var imageViewCity: UIImageView?
    @IBOutlet var lblCity: UILabel?
    @IBOutlet var txtCity: UITextField?
    @IBOutlet var txtCityBottomSeparatorView: UIView?
    
    @IBOutlet var txtAreaContainerView: UIView?
    @IBOutlet var imageViewArea: UIImageView?
    @IBOutlet var lblArea: UILabel?
    @IBOutlet var txtArea: UITextField?
    @IBOutlet var txtAreaBottomSeparatorView: UIView?
    
    @IBOutlet var txtMobileNumberContainerView: UIView?
    @IBOutlet var imageViewMobileNumber: UIImageView?
    @IBOutlet var lblMobileNumber: UILabel?
    @IBOutlet var txtMobileNumber: UITextField?
    @IBOutlet var txtMobileNumberBottomSeparatorView: UIView?
    
    @IBOutlet var btnDone: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var pickerState: UIPickerView = UIPickerView()
    var pickerCity: UIPickerView = UIPickerView()
    
    var datarowsState = [ObjState]()
    
    var objSelectedState: ObjState?
    var objSelectedCity: ObjCity?
    
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datarowsState = dataManager.arrayAllStates

        // Do any additional setup after loading the view.
        self.setupNotificationEvent()
        
        self.setUpNavigationBar()
        self.setupInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.removeNotificationEventObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        btnDone?.clipsToBounds = true
        btnDone?.layer.cornerRadius = (btnDone?.frame.size.height)!/2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (btnDone?.frame.origin.y)! + (btnDone?.frame.size.height)! + 20)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "PROFILE"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
    }
    
    @IBAction func btnMenuClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if(self.sideMenuController?.isLeftViewVisible)!
        {
            self.sideMenuController?.hideLeftViewAnimated()
        }
        else
        {
            self.sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_got_profile_detailsEvent),
                name: Notification.Name("user_got_profile_detailsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_updated_register_detailsEvent),
                name: Notification.Name("user_updated_register_detailsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_got_profile_detailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            // SET DATA
            
            self.txtFirstName?.text = UserDefaults.standard.value(forKey: "first_name") as? String ?? ""
            self.txtLastName?.text = UserDefaults.standard.value(forKey: "last_name") as? String ?? ""
            self.txtEmail?.text = UserDefaults.standard.value(forKey: "email") as? String ?? ""
            self.txtArea?.text = UserDefaults.standard.value(forKey: "area_name") as? String ?? ""
            self.txtMobileNumber?.text = UserDefaults.standard.value(forKey: "mobile_number") as? String ?? ""
            
            let strStateID : String = UserDefaults.standard.value(forKey: "state_id") as? String ?? ""
            let strCityID : String = UserDefaults.standard.value(forKey: "city_id") as? String ?? ""
            
            var i: NSInteger = 0
            for objState in self.datarowsState
            {
                if (objState.strStateID == strStateID)
                {
                    self.pickerView(self.pickerState, didSelectRow: i, inComponent: 0)
                    self.pickerState.selectRow(i, inComponent: 0, animated: false)
                    
                    var j: NSInteger = 0
                    for objCity in objState.arrayAllCity
                    {
                        if (objCity.strCityID == strCityID)
                        {
                            self.pickerView(self.pickerCity, didSelectRow: j, inComponent: 0)
                            self.pickerCity.selectRow(j, inComponent: 0, animated: false)
                        }
                        j = j + 1
                    }
                }
                i = i + 1
            }
            
        })
    }
    
    @objc func user_updated_register_detailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = dataManager.strServerMessage
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = true
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
            
            alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
            alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
            alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
            alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
            
            alertViewController.buttonColor = MySingleton.sharedManager().alertViewLeftButtonBackgroundColor
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController!.dismiss(animated: true, completion: nil)
            })
            
            alertViewController.addAction(okAction)
            
            self.navigationController!.present(alertViewController, animated: true, completion: nil)
            
        })
        
    }

    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        if #available(iOS 11.0, *)
        {
            mainScrollView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        mainScrollView?.delegate = self
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        var lblFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else
        {
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        
        // FIRST NAME
        imageViewFirstName?.layer.masksToBounds = true
        lblFirstName?.font = lblFont
        lblFirstName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblFirstName?.textAlignment = .left
        
        txtFirstName?.font = txtFont
        txtFirstName?.delegate = self
        txtFirstName?.tintColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtFirstName?.attributedPlaceholder = NSAttributedString(string: "Enter your first name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtFirstName?.textColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtFirstName?.textAlignment = .left
        txtFirstName?.autocorrectionType = UITextAutocorrectionType.no
        
        txtFirstNameBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // LAST NAME
        imageViewLastName?.layer.masksToBounds = true
        lblLastName?.font = lblFont
        lblLastName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblLastName?.textAlignment = .left
        
        txtLastName?.font = txtFont
        txtLastName?.delegate = self
        txtLastName?.tintColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtLastName?.attributedPlaceholder = NSAttributedString(string: "Enter your last name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtLastName?.textColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtLastName?.textAlignment = .left
        txtLastName?.autocorrectionType = UITextAutocorrectionType.no
        
        txtLastNameBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // EMAIL
        imageViewEmail?.layer.masksToBounds = true
        lblEmail?.font = lblFont
        lblEmail?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblEmail?.textAlignment = .left
        
        txtEmail?.font = txtFont
        txtEmail?.delegate = self
        txtEmail?.tintColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtEmail?.attributedPlaceholder = NSAttributedString(string: "Enter your email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtEmail?.textColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtEmail?.textAlignment = .left
        txtEmail?.autocorrectionType = UITextAutocorrectionType.no
        txtEmail?.keyboardType = .emailAddress
        
        txtEmailBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // STATE
        imageViewState?.layer.masksToBounds = true
        lblState?.font = lblFont
        lblState?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblState?.textAlignment = .left
        
        txtState?.font = txtFont
        txtState?.delegate = self
        txtState?.tintColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtState?.attributedPlaceholder = NSAttributedString(string: "Enter your state name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtState?.textColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtState?.textAlignment = .left
        txtState?.autocorrectionType = UITextAutocorrectionType.no
        
        txtStateBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        pickerState = UIPickerView()
        pickerState.delegate = self
        pickerState.dataSource = self
        txtState?.inputView = pickerState
        
        // CITY
        imageViewCity?.layer.masksToBounds = true
        lblCity?.font = lblFont
        lblCity?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblCity?.textAlignment = .left
        
        txtCity?.font = txtFont
        txtCity?.delegate = self
        txtCity?.tintColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtCity?.attributedPlaceholder = NSAttributedString(string: "Enter your city name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtCity?.textColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtCity?.textAlignment = .left
        txtCity?.autocorrectionType = UITextAutocorrectionType.no
        
        txtCityBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        pickerCity = UIPickerView()
        pickerCity.delegate = self
        pickerCity.dataSource = self
        txtCity?.inputView = pickerCity
        
        // AREA
        imageViewArea?.layer.masksToBounds = true
        lblArea?.font = lblFont
        lblArea?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblArea?.textAlignment = .left
        
        txtArea?.font = txtFont
        txtArea?.delegate = self
        txtArea?.tintColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtArea?.attributedPlaceholder = NSAttributedString(string: "Enter your area name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtArea?.textColor = MySingleton.sharedManager() .textfieldRedTextColor
        txtArea?.textAlignment = .left
        txtArea?.autocorrectionType = UITextAutocorrectionType.no
        
        txtAreaBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // MOBILE NUMBER
        imageViewMobileNumber?.layer.masksToBounds = true
        lblMobileNumber?.font = lblFont
        lblMobileNumber?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblMobileNumber?.textAlignment = .left
        
        txtMobileNumber?.font = txtFont
        txtMobileNumber?.delegate = self
        txtMobileNumber?.tintColor = MySingleton.sharedManager() .textfieldDisabledTextColor
        txtMobileNumber?.attributedPlaceholder = NSAttributedString(string: "Enter your mobile number.",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtMobileNumber?.textColor = MySingleton.sharedManager() .textfieldDisabledTextColor
        txtMobileNumber?.textAlignment = .left
        txtMobileNumber?.autocorrectionType = UITextAutocorrectionType.no
        txtMobileNumber?.isUserInteractionEnabled = false
        
        txtMobileNumberBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor?.withAlphaComponent(0.5)
        
        btnDone?.titleLabel?.font = txtFont
        btnDone?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnDone?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnDone?.addTarget(self, action: #selector(self.btnDoneClicked(_:)), for: .touchUpInside)
        
        //API CALL
        dataManager.user_get_profile_details()
    }

    // MARK: - Other Methods
    
    @IBAction func btnDoneClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((txtFirstName?.text?.count)! <= 0 || (txtLastName?.text?.count)! <= 0 || (txtEmail?.text?.count)! <= 0 || (txtState?.text?.count)! <= 0 || (txtCity?.text?.count)! <= 0 || (txtArea?.text?.count)! <= 0)
        {
            if (txtFirstName?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter your first name.")
            }
            else if (txtLastName?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter your last name.")
            }
            else if (txtEmail?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter your email.")
            }
            else if (txtState?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select your state.")
            }
            else if (txtCity?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select your city.")
            }
            else if (txtArea?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter area.")
            }
        }
        else
        {
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Are you sure you want to update your profile details?"
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = true
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
            
            alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
            alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
            alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
            alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
            
            alertViewController.buttonColor = MySingleton.sharedManager().alertViewLeftButtonBackgroundColor
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Yes",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    
                    dataManager.user_update_register_details(strFirstName: (self.txtFirstName?.text)!, strLastName: (self.txtLastName?.text)!, strEmail: (self.txtEmail?.text)!, strStateID: (self.objSelectedState?.strStateID)!, strCityID: (self.objSelectedCity?.strCityID)!, strArea: (self.txtArea?.text)!, strReferralCode: "")
            })
            
            // Add alert actions
            let cancelAction = NYAlertAction(
                title: "No",
                style: .cancel,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
            })
            
            alertViewController.addAction(okAction)
            alertViewController.addAction(cancelAction)
            
            self.navigationController?.present(alertViewController, animated: true, completion: nil)
            
            
            
        }
    }
    
    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (pickerView == pickerState)
        {
            return self.datarowsState.count
        }
        else
        {
            return (self.objSelectedState?.arrayAllCity.count)!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (pickerView == pickerState)
        {
            return self.datarowsState[row].strStateName
        }
        else
        {
            return self.objSelectedState?.arrayAllCity[row].strCityName
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (pickerView == pickerState)
        {
            self.objSelectedState = self.datarowsState[row]
            txtState?.text = self.datarowsState[row].strStateName
            pickerCity.reloadAllComponents()
            self.pickerView(pickerCity, didSelectRow: 0, inComponent: 0)
        }
        else
        {
            self.objSelectedCity = self.objSelectedState?.arrayAllCity[row]
            txtCity?.text = self.objSelectedState?.arrayAllCity[row].strCityName
        }
    }
    
    // MARK: - UITextField Delagate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
