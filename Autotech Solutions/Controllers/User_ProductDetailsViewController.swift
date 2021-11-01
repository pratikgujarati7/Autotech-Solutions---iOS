//
//  User_ProductDetailsViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 11/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift
import SDWebImage

class User_ProductDetailsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //BACK
    @IBOutlet var btnBackContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    
    @IBOutlet var imageViewProduct: UIImageView?
    @IBOutlet var imageBottomSetaratorView: UIView?
    @IBOutlet var lblProductName: UILabel?
    @IBOutlet var lblProductNameBottomSetaratorView: UIView?
    @IBOutlet var lblProductDescription: UILabel?
    @IBOutlet var btnInquire: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedCar: ObjCar!
    var objSelectedProduct: ObjProduct!
    
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
        
        btnInquire?.clipsToBounds = true
        btnInquire?.layer.cornerRadius = (btnInquire?.frame.size.height)!/2
        
        lblProductName?.sizeToFit()
        lblProductDescription?.sizeToFit()
        
        lblProductNameBottomSetaratorView?.frame.origin.y = (lblProductName?.frame.origin.y)! + (lblProductName?.frame.size.height)! + 10
        
        lblProductDescription?.frame.origin.y = (lblProductNameBottomSetaratorView?.frame.origin.y)! + (lblProductNameBottomSetaratorView?.frame.size.height)! + 10
        
        btnInquire?.frame.origin.y = (lblProductDescription?.frame.origin.y)! + (lblProductDescription?.frame.size.height)! + 10
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (btnInquire?.frame.origin.y)! + (btnInquire?.frame.size.height)! + 20)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewBack?.layer.masksToBounds = true
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "CAR CARE"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        lblNavigationTitle?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_inquired_productEvent),
                name: Notification.Name("user_inquired_productEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_inquired_productEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let viewController : Common_ThankYouViewController = Common_ThankYouViewController()
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
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        var txtTitleFont, lblFont, btnTitleFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            txtTitleFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtTitleFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        else
        {
            txtTitleFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
        }
        
        imageViewProduct?.contentMode = .scaleAspectFit
        imageViewProduct?.clipsToBounds = true
        imageViewProduct!.sd_setImage(with: URL(string: objSelectedProduct.strProductImageURL), placeholderImage: nil)
        
        imageBottomSetaratorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // CHOOSE YOUR CAR
        lblProductName?.font = txtTitleFont
        lblProductName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblProductName?.textAlignment = .left
        lblProductName?.numberOfLines = 0
        lblProductName?.text = objSelectedProduct.strProductName
        
        lblProductNameBottomSetaratorView?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        
        lblProductDescription?.font = lblFont
        lblProductDescription?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblProductDescription?.textAlignment = .left
        lblProductDescription?.numberOfLines = 0
        lblProductDescription?.text = objSelectedProduct.strProductDescription
        
        // INQUIRE
        btnInquire?.titleLabel?.font = txtFont
        btnInquire?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnInquire?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnInquire?.addTarget(self, action: #selector(self.btnInquireClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnInquireClicked(_ sender: UIButton)
    {
        //API CALL
        dataManager.user_inquire_product(strCarID: self.objSelectedCar.strCarID, strProductModelID: self.objSelectedProduct.strProductModelID)
    }

}
