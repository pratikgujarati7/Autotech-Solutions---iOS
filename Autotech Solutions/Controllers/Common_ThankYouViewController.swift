//
//  Common_ThankYouViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 11/03/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class Common_ThankYouViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    
    @IBOutlet var imageViewThankyou: UIImageView?
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var btnContinue: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        btnContinue?.clipsToBounds = true
        btnContinue?.layer.cornerRadius = (btnContinue?.frame.size.height)!/2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        lblNavigationTitle?.text = "SUCCESS"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        
    }
    
    @IBAction func btnMenuClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(self.user_added_addressEvent),
//                name: Notification.Name("user_added_addressEvent"),
//                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_added_addressEvent()
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
        
        var lblServiceFont, txtTitleFont, lblFont, btnTitleFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            lblServiceFont = MySingleton.sharedManager().themeFontTwentySizeBold
            txtTitleFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            lblServiceFont = MySingleton.sharedManager().themeFontTwentyOneSizeBold
            txtTitleFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        else
        {
            lblServiceFont = MySingleton.sharedManager().themeFontTwentyTwoSizeBold
            txtTitleFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
        }
        
        // DESCRIPTION
        lblDescription?.font = lblFont
        lblDescription?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblDescription?.textAlignment = .center
        
        // SAVE
        btnContinue?.titleLabel?.font = txtFont
        btnContinue?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnContinue?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnContinue?.addTarget(self, action: #selector(self.btnContinueClicked(_:)), for: .touchUpInside)
    }
    
    // MARK: - Other Methods
    
    @IBAction func btnContinueClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        //NAVIGATE TO HOME
        let viewController: User_HomeViewController = User_HomeViewController()
        
        let common_SideMenuViewController: User_SideMenuViewController = User_SideMenuViewController()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                      leftViewController: common_SideMenuViewController,
                                                      rightViewController: nil)
        
        sideMenuController.leftViewWidth = MySingleton.sharedManager().floatLeftSideMenuWidth!
        sideMenuController.leftViewPresentationStyle = MySingleton.sharedManager().leftViewPresentationStyle!
        
        sideMenuController.rightViewWidth = MySingleton.sharedManager().floatRightSideMenuWidth!
        sideMenuController.rightViewPresentationStyle = MySingleton.sharedManager().rightViewPresentationStyle!
        
        self.navigationController?.pushViewController(sideMenuController, animated: false)
    }
    
    // MARK: - UITextField Delagate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
