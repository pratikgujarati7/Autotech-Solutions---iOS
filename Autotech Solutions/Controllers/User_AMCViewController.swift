//
//  User_AMCViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 09/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_AMCViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //BACK
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var mainTableView: UITableView?
    
    //MAIN HEADER
    @IBOutlet var mainHeaderContainerView: UIView?
    @IBOutlet var lblChooseYourCar: UILabel?
    @IBOutlet var txtChooseYourCar: UITextField?
    @IBOutlet var txtChooseYourCarBottomSeparatorView: UIView?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarowsCars = [ObjCar]()
    var objSelectedCar: ObjCar?
    
    var CarPicker : UIPickerView = UIPickerView()
    
    var datarows = [ObjAMC]()
    
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
        navigationBarView?.backgroundColor = .clear
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "AMC"
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_got_my_car_listEvent),
                name: Notification.Name("user_got_my_car_listEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_got_all_amc_by_carEvent),
                name: Notification.Name("user_got_all_amc_by_carEvent"),
                object: nil)
            
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
    
    @objc func user_got_my_car_listEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarowsCars = dataManager.arrayAllMyCars
            if (self.datarowsCars.count > 0)
            {
                self.pickerView(self.CarPicker, didSelectRow: 0, inComponent: 0)
            }
            else
            {
                let alertViewController = NYAlertViewController()
                
                // Set a title and message
                alertViewController.title = ""
                alertViewController.message = "Please add your car from \"My Cars\" section."
                
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
                })
                
                alertViewController.addAction(okAction)
                
                self.navigationController!.present(alertViewController, animated: true, completion: nil)
            }
        })
    }
    
    @objc func user_got_all_amc_by_carEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayAllAMC
            self.mainTableView?.reloadData()
        })
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
        
        // CHOOSE YOUR CAR
        lblChooseYourCar?.font = lblFont
        lblChooseYourCar?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblChooseYourCar?.textAlignment = .left
        
        txtChooseYourCar?.font = txtFont
        txtChooseYourCar?.delegate = self
        txtChooseYourCar?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseYourCar?.attributedPlaceholder = NSAttributedString(string: "Select your car",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtChooseYourCar?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseYourCar?.textAlignment = .left
        txtChooseYourCar?.autocorrectionType = UITextAutocorrectionType.no
        
        txtChooseYourCarBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        CarPicker = UIPickerView()
        CarPicker.delegate = self
        CarPicker.dataSource = self
        txtChooseYourCar?.inputView = CarPicker
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalLightestGreyColor
        mainTableView?.isHidden = false
        
        // API CALL
        dataManager.user_get_my_car_list()
    }
    
    @IBAction func btnBuyNowClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (datarows.count > 0)
        {
            if (Int(self.datarows[sender.tag].strIsPurchased) == 0)
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
                        dataManager.user_inquire_amc(strCarID: self.objSelectedCar!.strCarID, strAmcID: self.datarows[sender.tag].strAMCID)
                        
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
    }


    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return (mainHeaderContainerView?.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return (mainHeaderContainerView)!
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
        if (self.datarows.count > 0)
        {
            return self.datarows.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (self.datarows.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:AMCTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AMCTableViewCell
            
            if(cell == nil)
            {
                cell = AMCTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblAMCTitle.frame.size.width = cell.mainContainer.frame.size.width - 20 - 80
            cell.lblAMCPrice.frame.size.width = 70
            cell.lblAMCSubTitle.frame.size.width = cell.mainContainer.frame.size.width - 20
            
            cell.lblAMCTitle.text = datarows[indexPath.row].strAMCTitle
            cell.lblAMCPrice.text = "₹ \(datarows[indexPath.row].strPrice)"
            cell.lblAMCPrice.adjustsFontSizeToFitWidth = true
            cell.lblAMCSubTitle.text = datarows[indexPath.row].strAMCDescription
            
            cell.lblAMCTitle.sizeToFit()
            cell.lblAMCSubTitle.frame.origin.y = cell.lblAMCTitle.frame.origin.y + cell.lblAMCTitle.frame.size.height + 10
            cell.lblAMCSubTitle.sizeToFit()
            
            cell.btnBuyNow.frame.origin.y = cell.lblAMCSubTitle.frame.origin.y + cell.lblAMCSubTitle.frame.size.height + 10
            
            if (Int(datarows[indexPath.row].strIsPurchased) == 0)
            {
                cell.btnBuyNow.isHidden = false
                
                cell.titleContainer.frame.size.height = cell.btnBuyNow.frame.origin.y + cell.btnBuyNow.frame.size.height + 10
            }
            else
            {
                cell.btnBuyNow.isHidden = true
                
                cell.titleContainer.frame.size.height = cell.lblAMCSubTitle.frame.origin.y + cell.lblAMCSubTitle.frame.size.height + 10
            }
            
            cell.mainContainer.frame.size.height = cell.titleContainer.frame.origin.y + cell.titleContainer.frame.size.height + 10
            
            return cell.mainContainer.frame.origin.y + cell.mainContainer.frame.size.height
        }
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (self.datarows.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:AMCTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AMCTableViewCell
            
            if(cell == nil)
            {
                cell = AMCTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblAMCTitle.frame.size.width = cell.mainContainer.frame.size.width - 20 - 80
            cell.lblAMCPrice.frame.size.width = 70
            cell.lblAMCSubTitle.frame.size.width = cell.mainContainer.frame.size.width - 20
            
            cell.lblAMCTitle.text = datarows[indexPath.row].strAMCTitle
            cell.lblAMCPrice.text = "₹ \(datarows[indexPath.row].strPrice)"
            cell.lblAMCPrice.adjustsFontSizeToFitWidth = true
            cell.lblAMCSubTitle.text = datarows[indexPath.row].strAMCDescription
            
            cell.btnBuyNow.tag = indexPath.row
            cell.btnBuyNow.addTarget(self, action: #selector(self.btnBuyNowClicked(_:)), for: .touchUpInside)
            
            cell.lblAMCTitle.sizeToFit()
            cell.lblAMCSubTitle.frame.origin.y = cell.lblAMCTitle.frame.origin.y + cell.lblAMCTitle.frame.size.height + 10
            cell.lblAMCSubTitle.sizeToFit()
            
            cell.btnBuyNow.frame.origin.y = cell.lblAMCSubTitle.frame.origin.y + cell.lblAMCSubTitle.frame.size.height + 10
            
            
            
            if (Int(datarows[indexPath.row].strIsPurchased) == 0)
            {
                cell.btnBuyNow.isHidden = false
                
                cell.titleContainer.frame.size.height = cell.btnBuyNow.frame.origin.y + cell.btnBuyNow.frame.size.height + 10
            }
            else
            {
                cell.btnBuyNow.isHidden = true
                
                cell.titleContainer.frame.size.height = cell.lblAMCSubTitle.frame.origin.y + cell.lblAMCSubTitle.frame.size.height + 10
            }
            
            cell.mainContainer.frame.size.height = cell.titleContainer.frame.origin.y + cell.titleContainer.frame.size.height + 10
            
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
            lblNoData.text = "No AMC found"
            
            cell.contentView.addSubview(lblNoData)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (datarows.count > 0)
        {
            let viewController : User_AMCCouponListViewController = User_AMCCouponListViewController()
            viewController.objSelectedCar = self.objSelectedCar!
            viewController.objSelectedAMC = datarows[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return datarowsCars.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(datarowsCars[row].strModelName) - \(datarowsCars[row].strRegistrationNumber)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        txtChooseYourCar?.text = "\(datarowsCars[row].strModelName) - \(datarowsCars[row].strRegistrationNumber)"
        self.objSelectedCar = datarowsCars[row]
        
        //API CALL
        dataManager.user_get_all_amc_by_car(strCarID: (self.objSelectedCar?.strCarID)!)
    }
    
    // MARK: - UITextField Delagate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == txtChooseYourCar)
        {
            if (self.datarowsCars.count > 0)
            {
                //self.pickerView(self.CarPicker, didSelectRow: 0, inComponent: 0)
            }
            else
            {
                textField.resignFirstResponder()
                
                let alertViewController = NYAlertViewController()
                
                // Set a title and message
                alertViewController.title = ""
                alertViewController.message = "Please add your car from \"My Cars\" section."
                
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
                })
                
                alertViewController.addAction(okAction)
                
                self.navigationController!.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIScrollView Delagate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        print(mainTableView?.contentOffset.y as Any)
        
        if scrollView == mainTableView
        {
            if Double((mainTableView?.contentOffset.y)!) <= 0
            {
                navigationBarView?.backgroundColor = .clear
            }
            else
            {
                navigationBarView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
            }
        }
    }

}
