//
//  User_AMCCouponListViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 06/04/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import NYAlertViewController
import IQKeyboardManagerSwift

class User_AMCCouponListViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
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
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedCar: ObjCar = ObjCar()
    var objSelectedAMC : ObjAMC = ObjAMC()
        
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
        
        if (Int(self.objSelectedAMC.strIsPurchased) == 0)
        {
            
        }
        else
        {
            
            mainTableView?.frame.size.height = (mainScrollView?.frame.size.height)!
            
            btnBuyNow?.isHidden = true
        }
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewBack?.layer.masksToBounds = true
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = objSelectedAMC.strAMCTitle//"AMC"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
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
        
        var txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        else
        {
            txtFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
        }
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalLightestGreyColor
        mainTableView?.isHidden = false
        
        btnBuyNow?.titleLabel?.font = txtFont
        btnBuyNow?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnBuyNow?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnBuyNow?.addTarget(self, action: #selector(self.btnBuyNowClicked(_:)), for: .touchUpInside)
    }
    
    // MARK: - Other Methods
    
    @IBAction func btnBuyNowClicked(_ sender: UIButton)
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (objSelectedAMC.arrayAllCoupons.count > 0)
        {
            return objSelectedAMC.arrayAllCoupons.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (objSelectedAMC.arrayAllCoupons.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:AMCCouponTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AMCCouponTableViewCell
            
            if(cell == nil)
            {
                cell = AMCCouponTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblAMCTitle.frame.size.width = cell.mainContainer.frame.size.width - 20
            cell.lblAMCSubTitle.frame.size.width = cell.mainContainer.frame.size.width - 20
            
            cell.lblLaborValue.frame.size.width = (cell.mainContainer.frame.size.width - 40)/2
            cell.lblPartsValue.frame.size.width = (cell.mainContainer.frame.size.width - 40)/2
            
            cell.lblAMCTitle.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strTitle
            cell.lblAMCSubTitle.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strSubTitle
            
            cell.lblLaborValue.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strLabourDetails
            cell.lblPartsValue.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strPartsDetails
            
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
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (objSelectedAMC.arrayAllCoupons.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:AMCCouponTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AMCCouponTableViewCell
            
            if(cell == nil)
            {
                cell = AMCCouponTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblAMCTitle.frame.size.width = cell.mainContainer.frame.size.width - 20
            cell.lblAMCSubTitle.frame.size.width = cell.mainContainer.frame.size.width - 20
            
            cell.lblLaborValue.frame.size.width = (cell.mainContainer.frame.size.width - 40)/2
            cell.lblPartsValue.frame.size.width = (cell.mainContainer.frame.size.width - 40)/2
            
            cell.lblAMCTitle.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strTitle
            cell.lblAMCSubTitle.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strSubTitle
            
            cell.lblLaborValue.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strLabourDetails
            cell.lblPartsValue.text = objSelectedAMC.arrayAllCoupons[indexPath.row].strPartsDetails
            
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
        else
        {
            var lblNoDataFont: UIFont?
            
            if MySingleton.sharedManager().screenWidth == 320
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            }
            else if MySingleton.sharedManager().screenWidth == 375
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            }
            else
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            }
            
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
            
            let lblNoData = UILabel(frame: CGRect(x: 0, y: 0, width: (mainTableView?.frame.size.width)!, height: cell.frame.size.height))
            lblNoData.textAlignment = NSTextAlignment.center
            lblNoData.font = lblNoDataFont
            lblNoData.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
            lblNoData.text = "No AMC coupons found"
            
            cell.contentView.addSubview(lblNoData)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (objSelectedAMC.arrayAllCoupons.count > 0)
        {
            let viewController : User_AMCDetailsViewController = User_AMCDetailsViewController()
            viewController.objSelectedCar = self.objSelectedCar
            viewController.objSelectedAMC = self.objSelectedAMC
            viewController.objSelectedAMCCoupon = objSelectedAMC.arrayAllCoupons[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

}
