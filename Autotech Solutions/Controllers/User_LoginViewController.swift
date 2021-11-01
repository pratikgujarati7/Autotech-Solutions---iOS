//
//  User_LoginViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 28/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController

class User_LoginViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var backgroundImageView: UIImageView?
    
    @IBOutlet var mainLogoImageView: UIImageView?
    @IBOutlet var mobileImageView: UIImageView?
    
    @IBOutlet var lblEnterMobile: UILabel?
    
    @IBOutlet var txtCountryCode: UITextField?
    @IBOutlet var txtCodeMobileSeparator: UIView?
    @IBOutlet var txtMobileNumber: UITextField?
    
    @IBOutlet var lblSMSSend: UILabel?
    
    @IBOutlet var nextContainerView: UIView?
    @IBOutlet var imageViewNext: UIImageView?
    @IBOutlet var btnNext: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNotificationEvent()
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
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(self,selector: #selector(self.user_registeredEvent),name: Notification.Name("user_registeredEvent"),object: nil)
            
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_registeredEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let viewController = User_VerifyMobileViewController()
            viewController.strMobileNumber = self.txtMobileNumber?.text
            self.navigationController?.pushViewController(viewController, animated: true)
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
        
//        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        mainLogoImageView?.layer.masksToBounds = true
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        var txtFont, lblEnterMobileFont, lblSMSSendFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            txtFont = MySingleton.sharedManager().themeFontTwentySizeRegular
            lblEnterMobileFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            lblSMSSendFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtFont = MySingleton.sharedManager().themeFontTwentyOneSizeRegular
            lblEnterMobileFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
            lblSMSSendFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
        }
        else
        {
            txtFont = MySingleton.sharedManager().themeFontTwentyTwoSizeRegular
            lblEnterMobileFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
            lblSMSSendFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
        }
        
        mobileImageView?.layer.masksToBounds = true
        
        lblEnterMobile?.font = lblEnterMobileFont
        lblEnterMobile?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblEnterMobile?.textAlignment = .center
        
        // COUNTRY CODE
        txtCountryCode?.font = txtFont;
        txtCountryCode?.delegate = self
        txtCountryCode?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtCountryCode?.attributedPlaceholder = NSAttributedString(string: "+91",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtCountryCode?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtCountryCode?.textAlignment = .center
        txtCountryCode?.autocorrectionType = UITextAutocorrectionType.no
        txtCountryCode?.keyboardType = UIKeyboardType.numberPad
        txtCountryCode?.isUserInteractionEnabled = false
        txtCountryCode?.text = "+91"
        
        // MOBILE
        txtMobileNumber?.font = txtFont;
        txtMobileNumber?.delegate = self
        txtMobileNumber?.tintColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtMobileNumber?.attributedPlaceholder = NSAttributedString(string: "9876543210",
                                                             attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderLoginColor!])
        txtMobileNumber?.textColor = MySingleton.sharedManager() .textfieldTextLoginColor
        txtMobileNumber?.textAlignment = NSTextAlignment.left
        txtMobileNumber?.autocorrectionType = UITextAutocorrectionType.no
        txtMobileNumber?.keyboardType = UIKeyboardType.numberPad
        
        lblSMSSend?.font = lblSMSSendFont
        lblSMSSend?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblSMSSend?.textAlignment = .center
        
        btnNext?.addTarget(self, action: #selector(self.btnNextClicked(_:)), for: .touchUpInside)
    }

    // MARK: - Other Methods
    
    @IBAction func btnNextClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (txtMobileNumber?.text?.count)! <= 0
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter your mobile number.")
        }
        else
        {
            let strDeviceToken : String = UserDefaults.standard.value(forKey: "device_token") as? String ?? ""
            //CALL WEB SERVICE
            dataManager.user_register(strMobile: (txtMobileNumber?.text)!, deviceToken: strDeviceToken)
        }
    }

}
