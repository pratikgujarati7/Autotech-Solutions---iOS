//
//  User_VerifyMobileViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 28/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController

class User_VerifyMobileViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var backgroundImageView: UIImageView?
    
    @IBOutlet var mobileImageView: UIImageView?
    
    @IBOutlet var lblPleaseVerifyNumber: UILabel?
    @IBOutlet var lblOTPDescription: UILabel?
    
    @IBOutlet var txtOtp1ContainerView: UIView?
    @IBOutlet var txtOtp1: UITextField?
    
    @IBOutlet var txtOtp2ContainerView: UIView?
    @IBOutlet var txtOtp2: UITextField?
    
    @IBOutlet var txtOtp3ContainerView: UIView?
    @IBOutlet var txtOtp3: UITextField?
    
    @IBOutlet var txtOtp4ContainerView: UIView?
    @IBOutlet var txtOtp4: UITextField?
    
    @IBOutlet var btnResendOTP: UIButton?
    
    @IBOutlet var nextContainerView: UIView?
    @IBOutlet var imageViewNext: UIImageView?
    @IBOutlet var btnNext: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var strMobileNumber: String!
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNotificationEvent()
        self.setupInitialView()
        
        lblOTPDescription?.text = "Please type the verification code sent to\n+91 \(strMobileNumber!)"
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
            
            NotificationCenter.default.addObserver(self,selector: #selector(self.user_verified_mobileEvent),name: Notification.Name("user_verified_mobileEvent"),object: nil)
            NotificationCenter.default.addObserver(self,selector: #selector(self.user_resent_otpEvent),name: Notification.Name("user_resent_otpEvent"),object: nil)
            
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_verified_mobileEvent()
    {
        DispatchQueue.main.async(execute: {
            
            if (dataManager.objLogedInUser.boolIsAlreadyRegistered)
            {
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
            }
            else
            {
                let viewController = User_RegisterViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        })
    }
    
    @objc func user_resent_otpEvent()
    {
        DispatchQueue.main.async(execute: {
            
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
        
        var txtFont, lblPleaseVerifyNumberFont, lblOTPDescriptionFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            txtFont = MySingleton.sharedManager().themeFontTwentySizeRegular
            lblPleaseVerifyNumberFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            lblOTPDescriptionFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtFont = MySingleton.sharedManager().themeFontTwentyOneSizeRegular
            lblPleaseVerifyNumberFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
            lblOTPDescriptionFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
        }
        else
        {
            txtFont = MySingleton.sharedManager().themeFontTwentyTwoSizeRegular
            lblPleaseVerifyNumberFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
            lblOTPDescriptionFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
        }
        
        mobileImageView?.layer.masksToBounds = true
        
        lblPleaseVerifyNumber?.font = lblPleaseVerifyNumberFont
        lblPleaseVerifyNumber?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblPleaseVerifyNumber?.textAlignment = .center
        
        //OTP 1
        txtOtp1ContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor?.withAlphaComponent(0.5)
        txtOtp1ContainerView?.layer.cornerRadius = 5
        txtOtp1ContainerView?.clipsToBounds = true
        
        txtOtp1?.delegate = self
        txtOtp1?.font = txtFont
        txtOtp1?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtOtp1?.textAlignment = .center
        txtOtp1?.keyboardType = .numberPad
        txtOtp1?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        //OTP 2
        txtOtp2ContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor?.withAlphaComponent(0.5)
        txtOtp2ContainerView?.layer.cornerRadius = 5
        txtOtp2ContainerView?.clipsToBounds = true
        
        txtOtp2?.delegate = self
        txtOtp2?.font = txtFont
        txtOtp2?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtOtp2?.textAlignment = .center
        txtOtp2?.keyboardType = .numberPad
        txtOtp2?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        //OTP 3
        txtOtp3ContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor?.withAlphaComponent(0.5)
        txtOtp3ContainerView?.layer.cornerRadius = 5
        txtOtp3ContainerView?.clipsToBounds = true
        
        txtOtp3?.delegate = self
        txtOtp3?.font = txtFont
        txtOtp3?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtOtp3?.textAlignment = .center
        txtOtp3?.keyboardType = .numberPad
        txtOtp3?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        //OTP 4
        txtOtp4ContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor?.withAlphaComponent(0.5)
        txtOtp4ContainerView?.layer.cornerRadius = 5
        txtOtp4ContainerView?.clipsToBounds = true
        
        txtOtp4?.delegate = self
        txtOtp4?.font = txtFont
        txtOtp4?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtOtp4?.textAlignment = .center
        txtOtp4?.keyboardType = .numberPad
        txtOtp4?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        lblOTPDescription?.font = lblOTPDescriptionFont
        lblOTPDescription?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblOTPDescription?.textAlignment = .center
        
        btnResendOTP?.titleLabel?.font = lblPleaseVerifyNumberFont
        btnResendOTP?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnResendOTP?.addTarget(self, action: #selector(self.btnResendOTPClicked(_:)), for: .touchUpInside)
        
        btnNext?.addTarget(self, action: #selector(self.btnNextClicked(_:)), for: .touchUpInside)

    }
    
    // MARK: - Other Methods
    
    @IBAction func btnResendOTPClicked(_ sender: UIButton)
    {
        dataManager.user_resend_otp(strMobile: strMobileNumber)
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (txtOtp1?.text?.count)! <= 0 || (txtOtp2?.text?.count)! <= 0 || (txtOtp3?.text?.count)! <= 0 || (txtOtp4?.text?.count)! <= 0
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter OTP.")
        }
        else
        {
//            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
//            let strAccessToken : String = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            let strOTP : String = String(format: "%@%@%@%@", (txtOtp1?.text)!, (txtOtp2?.text)!, (txtOtp3?.text)!, (txtOtp4?.text)!)


            //CALL WEB SERVICE
            dataManager.user_verify_mobile(strUserId: dataManager.objLogedInUser.strUserID, strAccessToken: dataManager.objLogedInUser.strAccessToken, strOtp: strOTP)
        }
    }
    
    // MARK: - UITextField Delagate Methods
    
    @IBAction func textFieldDidChange(_ sender: UITextField)
    {
        if sender == txtOtp1
        {
            if (txtOtp1?.text?.count)! > 0
            {
                txtOtp2?.becomeFirstResponder()
            }
        }
        if sender == txtOtp2
        {
            if (txtOtp2?.text?.count)! > 0
            {
                txtOtp3?.becomeFirstResponder()
            }
        }
        if sender == txtOtp3
        {
            if (txtOtp3?.text?.count)! > 0
            {
                txtOtp4?.becomeFirstResponder()
            }
        }
        if sender == txtOtp4
        {
            if (txtOtp4?.text?.count)! > 0
            {
                txtOtp4?.resignFirstResponder()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if (textField == txtOtp1 || textField == txtOtp2 || textField == txtOtp3 || textField == txtOtp4)
        {
            if (textField.text?.count)! > 0
            {
                textField.text = ""
            }
        }
        
        return true
    }

}
