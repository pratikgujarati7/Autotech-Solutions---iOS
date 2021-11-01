//
//  Common_TNCViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 12/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift
import WebKit

class Common_TNCViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //MENU
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    
    @IBOutlet weak var mainWebView: WKWebView?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var strUrl : String?
    
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
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "TERMS AND CONDITIONS"
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
        
        var btnFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenHeight == 480 || MySingleton.sharedManager().screenHeight == 568
        {
            btnFont = MySingleton.sharedManager().themeFontTwelveSizeBold
            txtFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
        }
        else if MySingleton.sharedManager().screenHeight == 667 || MySingleton.sharedManager().screenHeight == 812
        {
            btnFont = MySingleton.sharedManager().themeFontThirteenSizeBold
            txtFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
        }
        else
        {
            btnFont = MySingleton.sharedManager().themeFontFourteenSizeBold
            txtFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
        }
        
        mainWebView!.uiDelegate = self
        mainWebView!.navigationDelegate = self
        
        activityIndicatorView?.center = CGPoint.init(x: (mainWebView?.bounds.size.width)!/2, y: (mainWebView?.bounds.size.height)!/2)
        self.activityIndicatorView?.hidesWhenStopped = true
        mainWebView?.addSubview(activityIndicatorView!)
        
        let myURL = URL(string:strUrl!)
        let myRequest = URLRequest(url: myURL!)
        mainWebView!.load(myRequest)
        
        DispatchQueue.main.async {
            self.activityIndicatorView?.startAnimating()
        }
    }
    
    // MARK: - UIWebView Delegate Methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("Finished navigating to url \(webView.url)");
        
        DispatchQueue.main.async {
            self.activityIndicatorView?.stopAnimating()
        }
    }
    
    // MARK: - Other Methods
    
    @IBAction func btnSubmitClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
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
