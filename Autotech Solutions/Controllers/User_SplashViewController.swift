//
//  User_SplashViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 28/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController

class User_SplashViewController: UIViewController, UIScrollViewDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var mainLogoImageView: UIImageView?
    
    @IBOutlet var lblMultiBrandStore: UILabel?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsRedirected: Bool?
    
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsExecuteRedirectionCalledOnce: Bool = false
    
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
        UIApplication.shared.isStatusBarHidden = true
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
            
            NotificationCenter.default.addObserver(self,selector: #selector(self.user_got_splash_responceEvent),name: Notification.Name("user_got_splash_responceEvent"),object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_got_splash_responceEvent()
    {
        DispatchQueue.main.async(execute: {
            self.executeRedirection()
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
//        mainLogoImageView?.layer.masksToBounds = true
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        var lblMultiBrandStoreFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            lblMultiBrandStoreFont = MySingleton.sharedManager().themeFontFourteenSizeBold
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            lblMultiBrandStoreFont = MySingleton.sharedManager().themeFontFifteenSizeBold
        }
        else
        {
            lblMultiBrandStoreFont = MySingleton.sharedManager().themeFontSixteenSizeBold
        }
        
        lblMultiBrandStore?.font = lblMultiBrandStoreFont
        lblMultiBrandStore?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblMultiBrandStore?.backgroundColor = MySingleton.sharedManager().textfieldRedTextColor
        lblMultiBrandStore?.adjustsFontSizeToFitWidth = true
        
        //SPLASH CALL
        dataManager.user_get_splash_responce()
    }
    
    func executeRedirection()
    {
        let prefs = UserDefaults.standard
        let strUserId  = prefs.string(forKey: "user_id")
        let strAutoLogin  = prefs.string(forKey: "autologin")
        let strIsOpenedEarlier  = prefs.string(forKey: "is_opened_earlier")
        
        if (strUserId != nil && strUserId?.count != 0) && strAutoLogin == "1"
        {
            boolIsRedirected = true
            
           self.perform(#selector(User_SplashViewController.navigateToUserHomeViewController), with:self, afterDelay:1.0)
        }
        else
        {
            boolIsRedirected = true
            
            if strIsOpenedEarlier != nil && strIsOpenedEarlier?.count != 0
            {
                self.perform(#selector(User_SplashViewController.navigateToLoginScreen), with:self, afterDelay:1.0)
            }
            else
            {
                prefs.set("1", forKey: "is_opened_earlier")
                prefs.synchronize()
//                self.perform(#selector(User_SplashViewController.navigateToIntroductionScreen), with:self, afterDelay:1.0)
                self.perform(#selector(User_SplashViewController.navigateToLoginScreen), with:self, afterDelay:1.0)
            }
        }
    }
    
    // MARK: - Other Methods
    
    @objc func navigateToUserHomeViewController()
    {
        self.view.endEditing(true)
        //NAVIGATE TO HOME
        
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
    
    @objc func navigateToLoginScreen()
    {
        self.view.endEditing(true)
        //NAVIGATE TO LOGIN
        
        let viewController = User_LoginViewController()
        navigationController?.pushViewController(viewController, animated: false)
    }
    
//    @objc func navigateToIntroductionScreen()
//    {
//        self.view.endEditing(true)
//        //NAVIGATE TO LOGIN
//        
//        let viewController = Common_IntroductionViewController()
//        navigationController?.pushViewController(viewController, animated: false)
//    }
    
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
