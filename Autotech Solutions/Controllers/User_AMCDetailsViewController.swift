//
//  User_AMCDetailsViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 09/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_AMCDetailsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //BACK
    @IBOutlet var btnBackContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var mainTableView: UITableView?
    
    @IBOutlet var btnBuyNow: UIButton?
    
    // TERMS AND CONDITIONS
    @IBOutlet var termsAndConditionsContainerView: UIView?
    @IBOutlet var lblTncTitle: UILabel?
    @IBOutlet var lblTncText: UILabel?
    
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedCar: ObjCar!
    var objSelectedAMC: ObjAMC!
    var objSelectedAMCCoupon: ObjAMCCoupon!
    
    
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
        
        lblTncText?.text = objSelectedAMCCoupon.strTermsAndConditions
        lblTncText?.sizeToFit()
        
        termsAndConditionsContainerView?.frame.size.height = (lblTncText?.frame.origin.y)! + (lblTncText?.frame.size.height)! + 10
        mainTableView?.reloadData()
        
        if (Int(objSelectedAMC.strIsPurchased) == 1)
        {
            btnBuyNow?.setTitle("Redeem", for: .normal)
        }
        else
        {
            btnBuyNow?.setTitle("Buy Now", for: .normal)
        }
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewBack?.layer.masksToBounds = true
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        if (objSelectedAMC.strAMCTitle.count <= 20)
        {
            lblNavigationTitle?.text = objSelectedAMCCoupon.strTitle
        }
        else
        {
            lblNavigationTitle?.text = "AMC DETAILS"
        }
        
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
                selector: #selector(self.user_inquired_amcEvent),
                name: Notification.Name("user_inquired_amcEvent"),
                object: nil)
        }
    }

    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_inquired_amcEvent()
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
            txtTitleFont = MySingleton.sharedManager().themeFontFifteenSizeBold
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtTitleFont = MySingleton.sharedManager().themeFontSixteenSizeBold
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        else
        {
            txtTitleFont = MySingleton.sharedManager().themeFontSeventeenSizeBold
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
        }
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalLightestGreyColor
        mainTableView?.isHidden = false
        
        // CHOOSE YOUR CAR
        lblTncTitle?.font = txtTitleFont
        lblTncTitle?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        lblTncTitle?.textAlignment = .left
        
        lblTncText?.font = lblFont
        lblTncText?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblTncText?.textAlignment = .left
        lblTncText?.numberOfLines = 0
        
        btnBuyNow?.titleLabel?.font = txtFont
        btnBuyNow?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnBuyNow?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnBuyNow?.addTarget(self, action: #selector(self.btnBuyNowClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBuyNowClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (Int(objSelectedAMC.strIsPurchased) == 1)
        {
            let viewController : User_AMCRedeemViewController = User_AMCRedeemViewController()
            viewController.objSelectedCar = self.objSelectedCar
            viewController.objSelectedAMC = self.objSelectedAMC
            viewController.objSelectedAMCCoupon = self.objSelectedAMCCoupon
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Are you sure you want to buy this AMC?"
            
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
                title: "Yes",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    
                    // API CALL
                    dataManager.user_inquire_amc(strCarID: self.objSelectedCar.strCarID, strAmcID: self.objSelectedAMC.strAMCID)
                    
            })
            
            // Add alert actions
            let cancelAction = NYAlertAction(
                title: "No",
                style: .cancel,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
            })
            
            alertViewController.addAction(okAction)
            alertViewController.addAction(cancelAction)
            
            self.navigationController?.present(alertViewController, animated: true, completion: nil)
        }
    }

    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return (termsAndConditionsContainerView?.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return (termsAndConditionsContainerView)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:AMCCouponTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AMCCouponTableViewCell
        
        if(cell == nil)
        {
            cell = AMCCouponTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        cell.lblAMCTitle.text = objSelectedAMCCoupon!.strTitle
        cell.lblAMCSubTitle.text = objSelectedAMCCoupon!.strSubTitle
        
        cell.lblLaborValue.text = objSelectedAMCCoupon!.strLabourDetails
        cell.lblPartsValue.text = objSelectedAMCCoupon!.strPartsDetails
        
        cell.lblAMCTitle.sizeToFit()
        cell.lblAMCSubTitle.frame.origin.y = cell.lblAMCTitle.frame.origin.y + cell.lblAMCTitle.frame.size.height + 10
        cell.lblAMCSubTitle.sizeToFit()
        cell.titleContainer.frame.size.height = cell.lblAMCSubTitle.frame.origin.y + cell.lblAMCSubTitle.frame.size.height + 10
        
        cell.detailsContainer.frame.origin.y = cell.titleContainer.frame.origin.y + cell.titleContainer.frame.size.height
        
        if (cell.lblLaborValue.text == "")
        {
            cell.lblLaborTitle.isHidden = true
            cell.lblLaborValue.isHidden = true
            cell.verticalSeparatorView.isHidden = true
            
            cell.lblPartsTitle.frame.origin.x = cell.lblLaborTitle.frame.origin.x
            cell.lblPartsTitle.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblPartsTitle.frame.origin.x * 2)
            cell.lblPartsValue.frame.origin.x = cell.lblLaborValue.frame.origin.x
            cell.lblPartsValue.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblPartsValue.frame.origin.x * 2)
        }
        
        if (cell.lblPartsValue.text == "")
        {
            cell.lblPartsTitle.isHidden = true
            cell.lblPartsValue.isHidden = true
            cell.verticalSeparatorView.isHidden = true
            
            cell.lblLaborTitle.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblLaborTitle.frame.origin.x * 2)
            cell.lblLaborValue.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblLaborValue.frame.origin.x * 2)
        }
        
        cell.lblLaborValue.sizeToFit()
        cell.lblPartsValue.sizeToFit()
        
        if (cell.lblLaborValue.frame.size.height >= cell.lblPartsValue.frame.size.height)
        {
            cell.detailsContainer.frame.size.height = cell.lblLaborValue.frame.origin.y + cell.lblLaborValue.frame.size.height + 10
        }
        else
        {
            cell.detailsContainer.frame.size.height = cell.lblPartsValue.frame.origin.y + cell.lblPartsValue.frame.size.height + 10
        }
        
        cell.mainContainer.frame.size.height = cell.detailsContainer.frame.origin.y + cell.detailsContainer.frame.size.height
        
        return cell.mainContainer.frame.origin.y + cell.mainContainer.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:AMCCouponTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AMCCouponTableViewCell
        
        if(cell == nil)
        {
            cell = AMCCouponTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        cell.lblAMCTitle.text = objSelectedAMCCoupon!.strTitle
        cell.lblAMCSubTitle.text = objSelectedAMCCoupon!.strSubTitle
        
        cell.lblLaborValue.text = objSelectedAMCCoupon!.strLabourDetails
        cell.lblPartsValue.text = objSelectedAMCCoupon!.strPartsDetails
        
        cell.lblAMCTitle.sizeToFit()
        cell.lblAMCSubTitle.frame.origin.y = cell.lblAMCTitle.frame.origin.y + cell.lblAMCTitle.frame.size.height + 10
        cell.lblAMCSubTitle.sizeToFit()
        cell.titleContainer.frame.size.height = cell.lblAMCSubTitle.frame.origin.y + cell.lblAMCSubTitle.frame.size.height + 10
        
        cell.detailsContainer.frame.origin.y = cell.titleContainer.frame.origin.y + cell.titleContainer.frame.size.height
        
        if (cell.lblLaborValue.text == "")
        {
            cell.lblLaborTitle.isHidden = true
            cell.lblLaborValue.isHidden = true
            cell.verticalSeparatorView.isHidden = true
            
            cell.lblPartsTitle.frame.origin.x = cell.lblLaborTitle.frame.origin.x
            cell.lblPartsTitle.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblPartsTitle.frame.origin.x * 2)
            cell.lblPartsValue.frame.origin.x = cell.lblLaborValue.frame.origin.x
            cell.lblPartsValue.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblPartsValue.frame.origin.x * 2)
        }
        
        if (cell.lblPartsValue.text == "")
        {
            cell.lblPartsTitle.isHidden = true
            cell.lblPartsValue.isHidden = true
            cell.verticalSeparatorView.isHidden = true
            
            cell.lblLaborTitle.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblLaborTitle.frame.origin.x * 2)
            cell.lblLaborValue.frame.size.width = cell.detailsContainer.frame.size.width - (cell.lblLaborValue.frame.origin.x * 2)
        }
        
        cell.lblLaborValue.sizeToFit()
        cell.lblPartsValue.sizeToFit()
        
        if (cell.lblLaborValue.frame.size.height >= cell.lblPartsValue.frame.size.height)
        {
            cell.detailsContainer.frame.size.height = cell.lblLaborValue.frame.origin.y + cell.lblLaborValue.frame.size.height + 10
        }
        else
        {
            cell.detailsContainer.frame.size.height = cell.lblPartsValue.frame.origin.y + cell.lblPartsValue.frame.size.height + 10
        }
        
        cell.mainContainer.frame.size.height = cell.detailsContainer.frame.origin.y + cell.detailsContainer.frame.size.height
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
