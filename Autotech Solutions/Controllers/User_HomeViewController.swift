//
//  User_HomeViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 28/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_HomeViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //MENU
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    //NOTIFICATION
    @IBOutlet var btnNotificationContainerView: UIView?
    @IBOutlet var imageViewNotification: UIImageView?
    @IBOutlet var btnNotification: UIButton?
    //PROFILE
    @IBOutlet var btnProfileContainerView: UIView?
    @IBOutlet var imageViewProfile: UIImageView?
    @IBOutlet var btnProfile: UIButton?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var mainTableView: UITableView?
    
    //PROFILE
    @IBOutlet var btnAddCarContainerView: UIView?
    @IBOutlet var imageViewAddCar: UIImageView?
    @IBOutlet var btnAddCar: UIButton?
    
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
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "MITSUBISHI MOTORS"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        
        imageViewNotification?.layer.masksToBounds = true
        btnNotification?.addTarget(self, action: #selector(self.btnNotificationClicked(_:)), for: .touchUpInside)
        
        imageViewProfile?.layer.masksToBounds = true
        btnProfile?.addTarget(self, action: #selector(self.btnProfileClicked(_:)), for: .touchUpInside)
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
    
    @IBAction func btnNotificationClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
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
    
    @IBAction func btnProfileClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
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
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            //            NotificationCenter.default.addObserver(
            //                self,
            //                selector: #selector(self.user_gotAllServicesEvent),
            //                name: Notification.Name("user_gotAllServicesEvent"),
            //                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_gotAllServicesEvent()
    {
        
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
        
        var lblUserNameFont, lblUserEmailFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            lblUserNameFont = MySingleton.sharedManager().themeFontFourteenSizeBold
            lblUserEmailFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            lblUserNameFont = MySingleton.sharedManager().themeFontFifteenSizeBold
            lblUserEmailFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
        }
        else
        {
            lblUserNameFont = MySingleton.sharedManager().themeFontSixteenSizeBold
            lblUserEmailFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
        }
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = UIColor.clear
        mainTableView?.isHidden = false
        
        imageViewAddCar?.layer.masksToBounds = true
        btnAddCar?.addTarget(self, action: #selector(self.btnAddCarClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnAddCarClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController = User_MyCarsViewController()
        navigationController?.pushViewController(viewController, animated: true)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return HomeTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:HomeTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? HomeTableViewCell
        
        if(cell == nil)
        {
            cell = HomeTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        if indexPath.row == 0
        {
            cell.lblItemName.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
            cell.lblItemTitle.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        }
        else
        {
            cell.lblItemName.textColor = MySingleton.sharedManager().themeGlobalBlackColor
            cell.lblItemTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        }
        
        if indexPath.row == 0
        {
            cell.imageViewBackgroud.image = UIImage(named: "img_sos.png")
            cell.lblItemName.text = "Emergency"
            cell.lblItemTitle.text = "SOS Service"
        }
        else if indexPath.row == 1
        {
            cell.imageViewBackgroud.image = UIImage(named: "img_bookervice_3x.png")
            cell.lblItemName.text = "Book a"
            cell.lblItemTitle.text = "Service"
        }
        else if indexPath.row == 2
        {
            cell.imageViewBackgroud.image = UIImage(named: "img_bodyshop_3x.png")
            cell.lblItemName.text = "Book a"
            cell.lblItemTitle.text = "Bodyshop"
        }
        else if indexPath.row == 3
        {
            cell.imageViewBackgroud.image = UIImage(named: "img_amc_3x.png")
            cell.lblItemName.text = "Grab a"
            cell.lblItemTitle.text = "AMC"
        }
        else if indexPath.row == 4
        {
            cell.imageViewBackgroud.image = UIImage(named: "img_carcare_3x.png")
            cell.lblItemName.text = "Do my"
            cell.lblItemTitle.text = "Car Care"
        }
        else if indexPath.row == 5
        {
            cell.imageViewBackgroud.image = UIImage(named: "img_insaurance_3x.png")
            cell.lblItemName.text = "Insurance"
            cell.lblItemTitle.text = "Renewal"
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            self.view.endEditing(true)
            
            if let url = URL(string: "tel://\(dataManager.strSOSNumber)") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
        else if indexPath.row == 1
        {
            dataManager.currentAddress = ""
            dataManager.currentLocation = nil
            
            //NAVIGATE TO EDIT PROFILE
            let viewController: User_BookServiceViewController = User_BookServiceViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 2
        {
            dataManager.currentAddress = ""
            dataManager.currentLocation = nil
            
            //NAVIGATE TO BOOK BODYSHOP
            let viewController: User_BookBodyshopViewController = User_BookBodyshopViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 3
        {
            //NAVIGATE TO BOOK BODYSHOP
            let viewController: User_AMCViewController = User_AMCViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 4
        {
            //NAVIGATE TO BOOK BODYSHOP
            let viewController: User_CarCareViewController = User_CarCareViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 5
        {
            //NAVIGATE TO BOOK BODYSHOP
            let viewController: User_InsuranceRenewalViewController = User_InsuranceRenewalViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }

}
