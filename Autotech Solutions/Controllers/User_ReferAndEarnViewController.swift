//
//  User_ReferAndEarnViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 11/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_ReferAndEarnViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //BACK
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    
    @IBOutlet var lblYourFriends: UILabel?
    @IBOutlet var lblEarnMoney: UILabel?
    @IBOutlet var lblDescription: UILabel?
    
    @IBOutlet var imageViewBackgroung: UIImageView?
    
    @IBOutlet var detailsContainerView: UIView?
    @IBOutlet var imageViewInvite: UIImageView?
    @IBOutlet var lblInvite: UILabel?
    
    @IBOutlet var midSeparatorOne: UIView?
    
    @IBOutlet var imageViewProduct: UIImageView?
    @IBOutlet var lblProduct: UILabel?
    
    @IBOutlet var midSeparatorTwo: UIView?
    
    @IBOutlet var imageViewReward: UIImageView?
    @IBOutlet var lblReward: UILabel?
    
    @IBOutlet var lblYourCode: UILabel?
    @IBOutlet var lblYourCodeValue: UILabel?
    @IBOutlet var btnReferNow: UIButton?
    
    
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
        
        //DOTTED BORDER
        var yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!.cgColor
        yourViewBorder.lineDashPattern = [15, 7]
        yourViewBorder.lineWidth = 4
        yourViewBorder.frame = (lblYourCodeValue?.bounds)!
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: (lblYourCodeValue?.bounds)!).cgPath
        lblYourCodeValue?.layer.addSublayer(yourViewBorder)
        
        btnReferNow?.clipsToBounds = true
        btnReferNow?.layer.cornerRadius = (btnReferNow?.frame.size.height)! / 2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "REFER AND EARN"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
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
                selector: #selector(self.user_got_my_car_listEvent),
                name: Notification.Name("user_got_my_car_listEvent"),
                object: nil)
            
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_got_my_car_listEvent()
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
        
        var txtTitleFont, lblYourCodeValueFont, lblFont, btnTitleFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            txtTitleFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            lblYourCodeValueFont = MySingleton.sharedManager().themeFontTwentySizeBold
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtTitleFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            lblYourCodeValueFont = MySingleton.sharedManager().themeFontTwentyOneSizeBold
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        else
        {
            txtTitleFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
            lblYourCodeValueFont = MySingleton.sharedManager().themeFontTwentyTwoSizeBold
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
        }
        
        lblYourFriends?.font = lblFont
        lblYourFriends?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblYourFriends?.textAlignment = .center
        
        lblEarnMoney?.font = lblYourCodeValueFont
        lblEarnMoney?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblEarnMoney?.textAlignment = .center
        
        lblDescription?.font = btnTitleFont
        lblDescription?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblDescription?.textAlignment = .center
        lblDescription?.numberOfLines = 2
        lblDescription?.adjustsFontSizeToFitWidth = true
        
        detailsContainerView?.clipsToBounds = true
        detailsContainerView?.layer.cornerRadius = 10
        detailsContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        
        lblInvite?.font = btnTitleFont
        lblInvite?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblInvite?.textAlignment = .center
            lblYourCode?.numberOfLines = 2
        lblInvite?.adjustsFontSizeToFitWidth = true
        
        midSeparatorOne?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblProduct?.font = btnTitleFont
        lblProduct?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblProduct?.textAlignment = .center
        lblProduct?.numberOfLines = 2
        lblProduct?.adjustsFontSizeToFitWidth = true

        midSeparatorTwo?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblReward?.font = btnTitleFont
        lblReward?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblReward?.textAlignment = .center
        lblReward?.numberOfLines = 2
        lblReward?.adjustsFontSizeToFitWidth = true
        
        // CHOOSE YOUR CAR
        lblYourCode?.font = lblYourCodeValueFont
        lblYourCode?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblYourCode?.textAlignment = .center
        
        
        // CHOOSE YOUR CAR
        lblYourCodeValue?.font = lblYourCodeValueFont
        lblYourCodeValue?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblYourCodeValue?.textAlignment = .center
        lblYourCodeValue?.text = "\(UserDefaults.standard.value(forKey: "referral_code") ?? "")"
        
        btnReferNow?.titleLabel?.font = txtFont
        btnReferNow?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnReferNow?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnReferNow?.addTarget(self, action: #selector(self.btnReferNowClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnReferNowClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        //SHARE CLICKED
        let text = dataManager.strShareMessage
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - UITextField Delagate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

}
