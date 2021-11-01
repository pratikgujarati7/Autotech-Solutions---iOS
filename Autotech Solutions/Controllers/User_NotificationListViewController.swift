//
//  User_NotificationListViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 08/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_NotificationListViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //MENU
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var mainTableView: UITableView?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarows = [ObjNotification]()
    
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
        
        lblNavigationTitle?.text = "NOTIFICATIONS"
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_got_all_notification_listEvent),
                name: Notification.Name("user_got_all_notification_listEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_got_all_notification_listEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayAllNotifications
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
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
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = UIColor.clear
        mainTableView?.isHidden = true
        
        // API CALL
        dataManager.user_get_all_notification_list()
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
        if (datarows.count > 0)
        {
            return datarows.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (datarows.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:NotificationTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? NotificationTableViewCell
            
            if(cell == nil)
            {
                cell = NotificationTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblNotificationTitle.text = datarows[indexPath.row].strNotificationTitle
            cell.lblNotificationText.text = datarows[indexPath.row].strNotificationText
            
            cell.lblNotificationTitle.sizeToFit()
            cell.lblNotificationText.sizeToFit()
            
            cell.lblNotificationText.frame.origin.y = cell.lblNotificationTitle.frame.origin.y + cell.lblNotificationTitle.frame.size.height
            
            cell.mainContainer.frame.size.height = cell.lblNotificationText.frame.origin.y + cell.lblNotificationText.frame.size.height + 10
            
            return cell.mainContainer.frame.origin.y + cell.mainContainer.frame.size.height
        }
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (datarows.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:NotificationTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? NotificationTableViewCell
            
            if(cell == nil)
            {
                cell = NotificationTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblNotificationTitle.text = datarows[indexPath.row].strNotificationTitle
            cell.lblNotificationText.text = datarows[indexPath.row].strNotificationText
            
            cell.lblNotificationTitle.sizeToFit()
            cell.lblNotificationText.sizeToFit()
            
            cell.lblNotificationText.frame.origin.y = cell.lblNotificationTitle.frame.origin.y + cell.lblNotificationTitle.frame.size.height
            
            cell.mainContainer.frame.size.height = cell.lblNotificationText.frame.origin.y + cell.lblNotificationText.frame.size.height + 10
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell;
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
            lblNoData.text = "No notification found"
            
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
            
        }
    }

}
