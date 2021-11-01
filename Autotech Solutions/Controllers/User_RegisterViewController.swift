//
//  User_RegisterViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 28/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController

class User_RegisterViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var backgroundImageView: UIImageView?
    
    @IBOutlet var lblRegistration: UILabel?
    
    @IBOutlet var txtFirstNameContainerView: UIView?
    @IBOutlet var imageViewFirstName: UIImageView?
    @IBOutlet var lblFirstName: UILabel?
    @IBOutlet var txtFirstName: UITextField?
    
    @IBOutlet var txtLastNameContainerView: UIView?
    @IBOutlet var imageViewLastName: UIImageView?
    @IBOutlet var lblLastName: UILabel?
    @IBOutlet var txtLastName: UITextField?
    
    @IBOutlet var txtEmailContainerView: UIView?
    @IBOutlet var imageViewEmail: UIImageView?
    @IBOutlet var lblEmail: UILabel?
    @IBOutlet var txtEmail: UITextField?
    
    @IBOutlet var txtStateContainerView: UIView?
    @IBOutlet var imageViewState: UIImageView?
    @IBOutlet var lblState: UILabel?
    @IBOutlet var txtState: UITextField?
    
    @IBOutlet var txtCityContainerView: UIView?
    @IBOutlet var imageViewCity: UIImageView?
    @IBOutlet var lblCity: UILabel?
    @IBOutlet var txtCity: UITextField?
    
    @IBOutlet var txtAreaContainerView: UIView?
    @IBOutlet var imageViewArea: UIImageView?
    @IBOutlet var lblArea: UILabel?
    @IBOutlet var txtArea: UITextField?
    
    @IBOutlet var txtReferralCodeContainerView: UIView?
    @IBOutlet var imageViewReferralCode: UIImageView?
    @IBOutlet var lblReferralCode: UILabel?
    @IBOutlet var txtReferralCode: UITextField?
    
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
        self.setupInitialView()
        
        self.pickerView(pickerCity, didSelectRow: 0, inComponent: 0)
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
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(self,selector: #selector(self.user_updated_register_detailsEvent),name: Notification.Name("user_updated_register_detailsEvent"),object: nil)
            
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_updated_register_detailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            //NAVIGATE TO USER HOME
            let viewController: User_HomeViewController = User_HomeViewController()
            
            let common_SideMenuViewController: User_SideMenuViewController = User_SideMenuViewController()
            
            let navigationController = UINavigationController(rootViewController: viewController)
            
            let sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                          leftViewController: common_SideMenuViewController,
                                                          rightViewController: nil)
            
            sideMenuController.leftViewWidth = MySingleton.sharedManager().floatLeftSideMenuWidth!;
            sideMenuController.leftViewPresentationStyle = MySingleton.sharedManager().leftViewPresentationStyle!;
            
            sideMenuController.rightViewWidth = MySingleton.sharedManager().floatRightSideMenuWidth!;
            sideMenuController.rightViewPresentationStyle = MySingleton.sharedManager().rightViewPresentationStyle!;
            
            self.navigationController?.pushViewController(sideMenuController, animated: true)
            
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
        
        var lblRegistrationFont, lblFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            lblRegistrationFont = MySingleton.sharedManager().themeFontTwentySizeRegular
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            lblRegistrationFont = MySingleton.sharedManager().themeFontTwentyOneSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else
        {
            lblRegistrationFont = MySingleton.sharedManager().themeFontTwentyTwoSizeRegular
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        
        lblRegistration?.font = lblRegistrationFont
        lblRegistration?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblRegistration?.textAlignment = .center
        
        // FIRST NAME
        imageViewFirstName?.layer.masksToBounds = true
        lblFirstName?.font = lblFont
        lblFirstName?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblFirstName?.textAlignment = .left
        
        txtFirstName?.font = txtFont
        txtFirstName?.delegate = self
        txtFirstName?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtFirstName?.attributedPlaceholder = NSAttributedString(string: "Enter your first name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtFirstName?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtFirstName?.textAlignment = .left
        txtFirstName?.autocorrectionType = UITextAutocorrectionType.no
        
        // LAST NAME
        imageViewLastName?.layer.masksToBounds = true
        lblLastName?.font = lblFont
        lblLastName?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblLastName?.textAlignment = .left
        
        txtLastName?.font = txtFont
        txtLastName?.delegate = self
        txtLastName?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtLastName?.attributedPlaceholder = NSAttributedString(string: "Enter your last name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtLastName?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtLastName?.textAlignment = .left
        txtLastName?.autocorrectionType = UITextAutocorrectionType.no
        
        // EMAIL
        imageViewEmail?.layer.masksToBounds = true
        lblEmail?.font = lblFont
        lblEmail?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblEmail?.textAlignment = .left
        
        txtEmail?.font = txtFont
        txtEmail?.delegate = self
        txtEmail?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtEmail?.attributedPlaceholder = NSAttributedString(string: "Enter your email",
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtEmail?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtEmail?.textAlignment = .left
        txtEmail?.autocorrectionType = UITextAutocorrectionType.no
        txtEmail?.keyboardType = .emailAddress
        
        // STATE
        imageViewState?.layer.masksToBounds = true
        lblState?.font = lblFont
        lblState?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblState?.textAlignment = .left
        
        txtState?.font = txtFont
        txtState?.delegate = self
        txtState?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtState?.attributedPlaceholder = NSAttributedString(string: "Enter your state name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtState?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtState?.textAlignment = .left
        txtState?.autocorrectionType = UITextAutocorrectionType.no
        
        pickerState = UIPickerView()
        pickerState.delegate = self
        pickerState.dataSource = self
        txtState?.inputView = pickerState
        
        // CITY
        imageViewCity?.layer.masksToBounds = true
        lblCity?.font = lblFont
        lblCity?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblCity?.textAlignment = .left
        
        txtCity?.font = txtFont
        txtCity?.delegate = self
        txtCity?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtCity?.attributedPlaceholder = NSAttributedString(string: "Enter your city name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtCity?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtCity?.textAlignment = .left
        txtCity?.autocorrectionType = UITextAutocorrectionType.no
        
        pickerCity = UIPickerView()
        pickerCity.delegate = self
        pickerCity.dataSource = self
        txtCity?.inputView = pickerCity
        
        // AREA
        imageViewArea?.layer.masksToBounds = true
        lblArea?.font = lblFont
        lblArea?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblArea?.textAlignment = .left
        
        txtArea?.font = txtFont
        txtArea?.delegate = self
        txtArea?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtArea?.attributedPlaceholder = NSAttributedString(string: "Enter your area name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtArea?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtArea?.textAlignment = .left
        txtArea?.autocorrectionType = UITextAutocorrectionType.no
        
        // REFERRAL CODE
        imageViewReferralCode?.layer.masksToBounds = true
        lblReferralCode?.font = lblFont
        lblReferralCode?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblReferralCode?.textAlignment = .left
        
        txtReferralCode?.font = txtFont
        txtReferralCode?.delegate = self
        txtReferralCode?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtReferralCode?.attributedPlaceholder = NSAttributedString(string: "Enter referral code",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtReferralCode?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtReferralCode?.textAlignment = .left
        txtReferralCode?.autocorrectionType = UITextAutocorrectionType.no
        
        btnDone?.titleLabel?.font = txtFont
        btnDone?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        btnDone?.setTitleColor(MySingleton.sharedManager().themeGlobalRedColor, for: .normal)
        btnDone?.addTarget(self, action: #selector(self.btnDoneClicked(_:)), for: .touchUpInside)
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
            dataManager.user_update_register_details(strFirstName: (txtFirstName?.text)!, strLastName: (txtLastName?.text)!, strEmail: (txtEmail?.text)!, strStateID: (objSelectedState?.strStateID)!, strCityID: (objSelectedCity?.strCityID)!, strArea: (txtArea?.text)!, strReferralCode: (txtReferralCode?.text)!)
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
}
