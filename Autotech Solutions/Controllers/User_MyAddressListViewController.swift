//
//  User_MyAddressListViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 26/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_MyAddressListViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
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
    
    //ADD
    @IBOutlet var btnAddContainerView: UIView?
    @IBOutlet var imageViewAdd: UIImageView?
    @IBOutlet var btnAdd: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsForSelection: Bool = false
    
    var datarows = [ObjAddress]()
    
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
        
        // API CALL
        dataManager.user_get_all_address_list()
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
        
        if (boolIsForSelection == true)
        {
            imageViewMenu?.image = UIImage(named: "ic_backb@3x.png")
            //btnAddContainerView?.isHidden = true
        }
        
        lblNavigationTitle?.text = "MY ADDRESS BOOK"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
    }
    
    @IBAction func btnMenuClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (boolIsForSelection == true)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            if(self.sideMenuController?.isLeftViewVisible)!
            {
                self.sideMenuController?.hideLeftViewAnimated()
            }
            else
            {
                self.sideMenuController?.showLeftView(animated: true, completionHandler: nil)
            }
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
                selector: #selector(self.user_got_all_address_listEvent),
                name: Notification.Name("user_got_all_address_listEvent"),
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_deleted_addressEvent),
                name: Notification.Name("user_deleted_addressEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_got_all_address_listEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayAllAddress
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_deleted_addressEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayAllAddress
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
        
        imageViewAdd?.layer.masksToBounds = true
        btnAdd?.addTarget(self, action: #selector(self.btnAddClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnAddClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController = User_AddAddressViewController()
        viewController.boolIsForSelection = self.boolIsForSelection
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
            var cell:AddressTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AddressTableViewCell
            
            if(cell == nil)
            {
                cell = AddressTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblAddressTitle.text = datarows[indexPath.row].strAddressTitle
            cell.lblAddressText.text = datarows[indexPath.row].strAddress
            
            cell.lblAddressTitle.sizeToFit()
            cell.lblAddressText.sizeToFit()
            
            cell.lblAddressText.frame.origin.y = cell.lblAddressTitle.frame.origin.y + cell.lblAddressTitle.frame.size.height
            
            cell.mainContainer.frame.size.height = cell.lblAddressText.frame.origin.y + cell.lblAddressText.frame.size.height + 10
            
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
            var cell:AddressTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? AddressTableViewCell
            
            if(cell == nil)
            {
                cell = AddressTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblAddressTitle.text = datarows[indexPath.row].strAddressTitle
            cell.lblAddressText.text = datarows[indexPath.row].strAddress
            
            cell.lblAddressTitle.sizeToFit()
            cell.lblAddressText.sizeToFit()
            
            cell.lblAddressText.frame.origin.y = cell.lblAddressTitle.frame.origin.y + cell.lblAddressTitle.frame.size.height
            
            cell.mainContainer.frame.size.height = cell.lblAddressText.frame.origin.y + cell.lblAddressText.frame.size.height + 10
            
            if (boolIsForSelection == true)
            {
                cell.btnDelete.isHidden = true
                cell.imageViewDelete.isHidden = true
            }
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteClicked(_:)), for: .touchUpInside)
            
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
            lblNoData.text = "No address found"
            
            cell.contentView.addSubview(lblNoData)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        
    }
    
    @IBAction func btnDeleteClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = ""
        alertViewController.message = "Are you sure you want to delete this address?"
        
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
                dataManager.user_delete_address(strAddressID: self.datarows[sender.tag].strAddressID)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (datarows.count > 0)
        {
            dataManager.currentAddress = datarows[indexPath.row].strAddress
            self.navigationController?.popViewController(animated: true)
        }
    }
}
