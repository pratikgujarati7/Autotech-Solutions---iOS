//
//  User_AddAddressViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 26/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_AddAddressViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
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
    
    //HEADER ONE
    @IBOutlet var mainHeaderOneContainerView: UIView?
    
    @IBOutlet var lblAddressTitle: UILabel?
    @IBOutlet var txtAddressTitle: UITextField?
    @IBOutlet var txtAddressTitleBottomSeparatorView: UIView?
    
    @IBOutlet var lblAddress: UILabel?
    @IBOutlet var txtViewAddress: UITextView?
    @IBOutlet var txtViewAddressBottomSeparatorView: UIView?
    
    //HEADER TWO
    @IBOutlet var mainHeaderTwoContainerView: UIView?
    @IBOutlet var btnSave: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsForSelection: Bool = false
    
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
        
        btnSave?.clipsToBounds = true
        btnSave?.layer.cornerRadius = (btnSave?.frame.size.height)!/2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "ADD ADDRESS"
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
                selector: #selector(self.user_added_addressEvent),
                name: Notification.Name("user_added_addressEvent"),
                object: nil)
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
                    
                    if (self.boolIsForSelection)
                    {
                        self.navigationController?.popViewController(animated: false)
                    }
                    else
                    {
                        //NAVIGATE TO HOME
                        let viewController: User_MyAddressListViewController = User_MyAddressListViewController()
                        
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
        
        // ADDRESS TITLE
        lblAddressTitle?.font = lblFont
        lblAddressTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAddressTitle?.textAlignment = .left
        
        txtAddressTitle?.font = txtFont
        txtAddressTitle?.delegate = self
        txtAddressTitle?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtAddressTitle?.attributedPlaceholder = NSAttributedString(string: "Enter address title",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtAddressTitle?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtAddressTitle?.textAlignment = .left
        txtAddressTitle?.autocorrectionType = UITextAutocorrectionType.no
        
        txtAddressTitleBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // ADDRESS
        lblAddress?.font = lblFont
        lblAddress?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAddress?.textAlignment = .left
        
        txtViewAddress?.font = txtFont
        txtViewAddress?.delegate = self
        txtViewAddress?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtViewAddress?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtViewAddress?.textAlignment = .left
        txtViewAddress?.autocorrectionType = UITextAutocorrectionType.no
        txtViewAddress?.layer.borderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor?.cgColor
        txtViewAddress?.layer.borderWidth = 1
        txtViewAddress?.clipsToBounds = true
        txtViewAddress?.layer.cornerRadius = 5

        txtViewAddressBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // SAVE
        btnSave?.titleLabel?.font = txtFont
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnSave?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnSave?.addTarget(self, action: #selector(self.btnSaveClicked(_:)), for: .touchUpInside)
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = UIColor.clear
        mainTableView?.isHidden = false
    }
    
    // MARK: - Other Methods
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        if ((txtAddressTitle?.text?.count)! <= 0 || (txtViewAddress?.text?.count)! <= 0)
        {
            if (txtAddressTitle?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter address title.")
            }
            else if (txtViewAddress?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter address.")
            }
        }
        else
        {
            //API CALL
            dataManager.user_add_address(strAddressTitle: (txtAddressTitle?.text)!, strAddress: (txtViewAddress?.text)!)
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0)
        {
            return (mainHeaderOneContainerView?.frame.size.height)!
        }
        else
        {
            return (mainHeaderTwoContainerView?.frame.size.height)!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if (section == 0)
        {
            return (mainHeaderOneContainerView)!
        }
        else
        {
            return (mainHeaderTwoContainerView)!
        }
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
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
