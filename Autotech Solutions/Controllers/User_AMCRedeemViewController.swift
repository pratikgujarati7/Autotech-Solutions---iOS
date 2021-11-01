//
//  User_AMCRedeemViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 11/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift
import MTBBarcodeScanner

class User_AMCRedeemViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate
{
    
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //BACK
    @IBOutlet var btnBackContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?

    @IBOutlet var lblInstructions: UILabel?
    @IBOutlet var barCodeScannerOverlayView: UIView?
    @IBOutlet var lblOr: UILabel?
    @IBOutlet var lblEnterManually: UILabel?
    @IBOutlet var txtCode: UITextField?
    @IBOutlet var txtCodeBottomSeparatorView: UIView?
    @IBOutlet var btnRedeem: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedCar: ObjCar!
    var objSelectedAMC: ObjAMC!
    var objSelectedAMCCoupon: ObjAMCCoupon!    
    
    var scanner: MTBBarcodeScanner?
    var strScannedCode: NSString = ""
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scanner = MTBBarcodeScanner(previewView: barCodeScannerOverlayView)
        
        self.setupNotificationEvent()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        self.startScanning()
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
        
        btnRedeem?.clipsToBounds = true
        btnRedeem?.layer.cornerRadius = (btnRedeem?.frame.size.height)! / 2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewBack?.layer.masksToBounds = true
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = objSelectedAMC.strAMCTitle
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
                selector: #selector(self.user_redeemed_amcEvent),
                name: Notification.Name("user_redeemed_amcEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_redeemed_amcEvent()
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
        
        var txtTitleFont, lblFont, btnTitleFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            txtTitleFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeBold
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtTitleFont = MySingleton.sharedManager().themeFontNineteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeBold
        }
        else
        {
            txtTitleFont = MySingleton.sharedManager().themeFontTwentySizeRegular
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontEighteenSizeBold
        }
        
        // CHOOSE YOUR CAR
        lblInstructions?.font = txtTitleFont
        lblInstructions?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        lblInstructions?.textAlignment = .center
        
        lblOr?.font = txtTitleFont
        lblOr?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblOr?.textAlignment = .center
        
        lblEnterManually?.font = txtTitleFont
        lblEnterManually?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        lblEnterManually?.textAlignment = .center
        
        // CODE
        
        txtCode?.font = txtFont
        txtCode?.delegate = self
        txtCode?.tintColor = MySingleton.sharedManager() .textfieldTextColor
        txtCode?.attributedPlaceholder = NSAttributedString(string: "Enter Code",
                                                             attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtCode?.textColor = MySingleton.sharedManager() .textfieldTextColor
        txtCode?.textAlignment = .left
        txtCode?.autocorrectionType = UITextAutocorrectionType.no
        
        txtCodeBottomSeparatorView?.backgroundColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        btnRedeem?.titleLabel?.font = txtFont
        btnRedeem?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnRedeem?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnRedeem?.addTarget(self, action: #selector(self.btnRedeemClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnRedeemClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (txtCode?.text?.count)! <= 0
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter code.")
        }
        else
        {
            //API CALL
            dataManager.user_redeem_amc(strAmcUserID: objSelectedAMC.strAMCUserID, strAmcType: objSelectedAMC.strAMCType, strAmcCouponID: self.objSelectedAMCCoupon.strAMCCouponID, strPin: (txtCode?.text)!)
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
    
    func startScanning()
    {
        self.txtCode?.text = ""
        self.strScannedCode = ""
        
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            for code in codes {
                                let stringValue = code.stringValue!
                                print("Found code: \(stringValue)")
                                
                                self.txtCode?.text = stringValue
                                
                            }
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else {
                self.appDelegate?.showAlertViewWithTitle(title: "Scanning Unavailable", detail: "This app does not have permission to access the camera")
            }
        })
    }


}
