//
//  Common_AboutUsViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 12/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class Common_AboutUsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //MENU
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    
    @IBOutlet weak var imageViewAppIcon: UIImageView?
    @IBOutlet weak var lblAppName: UILabel?
    @IBOutlet weak var lblVersionNumber: UILabel?
    @IBOutlet weak var topSeparatorView: UIView?
    @IBOutlet weak var lblAboutUsText: UILabel?
    @IBOutlet weak var bottomSeparatorView: UIView?
    
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
        
        lblAboutUsText?.sizeToFit()
        
        var bottomSeparatorViewFrame : CGRect = bottomSeparatorView!.frame
        bottomSeparatorViewFrame.origin.y = (lblAboutUsText?.frame.origin.y)! + (lblAboutUsText?.frame.size.height)! + 10
        bottomSeparatorView!.frame = bottomSeparatorViewFrame
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (bottomSeparatorView?.frame.origin.y)! + (bottomSeparatorView?.frame.size.height)! + 10)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "ABOUT US"
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
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
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
        
        var lblAppNameFont, lblVersionNumberFont, lblAboutUsTextFont, lblShareAppFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            lblAppNameFont = MySingleton.sharedManager().themeFontTwentyFourSizeBold
            lblVersionNumberFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
            lblAboutUsTextFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            lblShareAppFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            lblAppNameFont = MySingleton.sharedManager().themeFontTwentyFiveSizeBold
            lblVersionNumberFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
            lblAboutUsTextFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            lblShareAppFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
        }
        else
        {
            lblAppNameFont = MySingleton.sharedManager().themeFontTwentySixSizeBold
            lblVersionNumberFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            lblAboutUsTextFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            lblShareAppFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        
        lblAppName?.font = lblAppNameFont
        lblAppName?.textColor = MySingleton .sharedManager().themeGlobalRedColor
        lblAppName?.textAlignment = .center
        
        lblVersionNumber?.font = lblVersionNumberFont
        lblVersionNumber?.textColor = MySingleton .sharedManager().themeGlobalBlackColor
        lblVersionNumber?.textAlignment = .center
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        lblVersionNumber?.text = "Version \(nsObject as! String)"
        
        lblAboutUsText?.font = lblAboutUsTextFont
        lblAboutUsText?.textColor = MySingleton .sharedManager().themeGlobalDarkGreyColor
        lblAboutUsText?.textAlignment = .justified
        lblAboutUsText?.text = dataManager.strAboutAppText
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
