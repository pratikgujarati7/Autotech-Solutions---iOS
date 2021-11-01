//
//  User_SideMenuViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 28/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import LGSideMenuController

class User_SideMenuViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var mainTableView: UITableView?
    
    @IBOutlet var headerView: UIView?
    @IBOutlet var mainLogoImageView: UIImageView?
    @IBOutlet var lblMultiBrandStore: UILabel?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNotificationEvent()
        self.setupInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.sideMenuController?.isLeftViewSwipeGestureEnabled = false
        self.sideMenuController?.isRightViewSwipeGestureEnabled = false
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.removeNotificationEventObserver()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (headerView?.frame.size.height)! + (SideMenuTableViewCellHeight * 8))
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(self,selector: #selector(self.user_logedoutEvent),name: Notification.Name("user_logedoutEvent"),object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_logedoutEvent()
    {
        DispatchQueue.main.async(execute: {
            // CLEAR USER PREFERANCE
            UserDefaults.standard.removeObject(forKey: "mobile_number")
            UserDefaults.standard.removeObject(forKey: "user_id")
            UserDefaults.standard.removeObject(forKey: "first_name")
            UserDefaults.standard.removeObject(forKey: "last_name")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "area_id")
            UserDefaults.standard.removeObject(forKey: "area_name")
            UserDefaults.standard.removeObject(forKey: "city_id")
            UserDefaults.standard.removeObject(forKey: "city_name")
            UserDefaults.standard.removeObject(forKey: "referral_code")
            UserDefaults.standard.removeObject(forKey: "user_is_verified")
            UserDefaults.standard.removeObject(forKey: "autologin")
            UserDefaults.standard.removeObject(forKey: "is_already_registered")
            UserDefaults.standard.synchronize()
            
            //NAVIGATE TO LOGIN
            let viewController = User_LoginViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
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
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        mainScrollView?.delegate = self
        mainScrollView?.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = MySingleton.sharedManager() .themeGlobalWhiteColor
        
        self.headerView?.backgroundColor = MySingleton.sharedManager() .themeGlobalLightestGreyColor
        
        self.mainLogoImageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
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
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = UIColor.clear
        mainTableView?.isHidden = false
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return (headerView?.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return SideMenuTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:SideMenuTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? SideMenuTableViewCell
        
        if(cell == nil)
        {
            cell = SideMenuTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        if indexPath.row == MySingleton.sharedManager() .selectedScreenIndex
        {
            cell.mainContainer.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        }
        else
        {
            cell.mainContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        }
        
        if indexPath.row == 0
        {
            cell.imageViewItem.image = UIImage(named: "ic_home.png")
            cell.lblItemName.text = "Home"
        }
        else if indexPath.row == 1
        {
            cell.imageViewItem.image = UIImage(named: "ic_mycar.png")
            cell.lblItemName.text = "My Cars"
        }
        else if indexPath.row == 2
        {
            cell.imageViewItem.image = UIImage(named: "ic_profile.png")
            cell.lblItemName.text = "Profile"
        }
        else if indexPath.row == 3
        {
            cell.imageViewItem.image = UIImage(named: "addressbook.png")
            cell.lblItemName.text = "My Address Book"
        }
        else if indexPath.row == 4
        {
            cell.imageViewItem.image = UIImage(named: "ic_notification.png")
            cell.lblItemName.text = "Notifications"
        }
        else if indexPath.row == 5
        {
            cell.imageViewItem.image = UIImage(named: "ic_refer.png")
            cell.lblItemName.text = "Refer and Earn"
        }
        else if indexPath.row == 6
        {
            cell.imageViewItem.image = UIImage(named: "ic_terms.png")
            cell.lblItemName.text = "Terms & Conditions"
        }
        else if indexPath.row == 7
        {
            cell.imageViewItem.image = UIImage(named: "ic_about.png")
            cell.lblItemName.text = "About Us"
        }
        else if indexPath.row == 8
        {
            cell.imageViewItem.image = UIImage(named: "ic_logout.png")
            cell.lblItemName.text = "Logout"
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        MySingleton.sharedManager() .selectedScreenIndex = indexPath.row
        
        if indexPath.row == 0
        {
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
        }
        else if indexPath.row == 1
        {
            //NAVIGATE TO MY CARS
            let viewController: User_MyCarsViewController = User_MyCarsViewController()
            
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
        else if indexPath.row == 2
        {
            //NAVIGATE TO EDIT PROFILE
            let viewController: User_EditProfileViewController = User_EditProfileViewController()
            
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
        else if indexPath.row == 3
        {
            //NAVIGATE TO MY ADDRESS BOOK
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
        else if indexPath.row == 4
        {
            //NAVIGATE TO NOTIFICATION
            let viewController: User_NotificationListViewController = User_NotificationListViewController()
            
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
        else if indexPath.row == 5
        {
            //NAVIGATE TO REFER AND EARN
            let viewController: User_ReferAndEarnViewController = User_ReferAndEarnViewController()
            
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
        else if indexPath.row == 6
        {
            //NAVIGATE TO REFER AND EARN
            let viewController: Common_TNCViewController = Common_TNCViewController()
            viewController.strUrl = "http://credencetech.in/autotech-solution/autotech_tnc.html"
            
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
        else if indexPath.row == 7
        {
            //NAVIGATE TO REFER AND EARN
            let viewController: Common_AboutUsViewController = Common_AboutUsViewController()
            
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
        else if indexPath.row == 8
        {
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Are you sure you want to logout?"
            
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
                    
                    //API CALL
                    dataManager.user_logout()
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
