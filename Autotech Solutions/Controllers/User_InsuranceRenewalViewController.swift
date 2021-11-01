//
//  User_InsuranceRenewalViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 09/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift

class User_InsuranceRenewalViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate
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
    @IBOutlet var mainHeaderBackgroundImageView: UIImageView?
    @IBOutlet var lblInsurance: UILabel?
    @IBOutlet var lblRenewal: UILabel?
    
    //HEADER TWO
    @IBOutlet var mainHeaderTwoContainerView: UIView?
    @IBOutlet var lblChooseInsuranceCompany: UILabel?
    @IBOutlet var txtChooseInsuranceCompany: UITextField?
    @IBOutlet var txtChooseInsuranceCompanyBottomSeparatorView: UIView?
    
    @IBOutlet var lblChooseYourCar: UILabel?
    @IBOutlet var txtChooseYourCar: UITextField?
    @IBOutlet var txtChooseYourCarBottomSeparatorView: UIView?
    
    @IBOutlet var lblPolicyNumber: UILabel?
    @IBOutlet var txtPolicyNumber: UITextField?
    @IBOutlet var txtPolicyNumberBottomSeparatorView: UIView?
    
    @IBOutlet var lblExpiryDate: UILabel?
    @IBOutlet var txtExpiryDate: UITextField?
    @IBOutlet var txtExpiryDateBottomSeparatorView: UIView?
    
    @IBOutlet var lblYearOfMenufacture: UILabel? //1900- 2019
    @IBOutlet var txtYearOfMenufacture: UITextField?
    @IBOutlet var txtYearOfMenufactureBottomSeparatorView: UIView?
    
    //HEADER FOUR
    @IBOutlet var mainHeaderThreeContainerView: UIView?
    @IBOutlet var btnDone: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsHavingInsurancePolicy: Bool = false
    
    var datarowsInsuranceCompany = [ObjInsuranceCompany]()
    var objSelectedInsuranceCompany: ObjInsuranceCompany?
    
    var datarows = [ObjCar]()
    var objSelectedCar: ObjCar?
    
    var datarowsYears = [String]()
    
    var InsuranceCompanyPicker : UIPickerView = UIPickerView()
    var CarPicker : UIPickerView = UIPickerView()
    let datePickerView:UIDatePicker = UIDatePicker()
    var YearPicker : UIPickerView = UIPickerView()
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datarowsYears = [String]()
        for index in 1900...2019
        {
            datarowsYears.append("\(index)")
        }
        var reversedNames : [String] = Array(datarowsYears.reversed())
        datarowsYears = reversedNames

        // Do any additional setup after loading the view.
        self.setupNotificationEvent()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        datarowsInsuranceCompany = dataManager.arrayAllInsuranceCompanies
        InsuranceCompanyPicker.reloadAllComponents()
        self.pickerView(InsuranceCompanyPicker, didSelectRow: 0, inComponent: 0)
        self.datePickerView.date = Date()
        self.datePickerValueChanged(sender: self.datePickerView)
        
        YearPicker.reloadAllComponents()
        self.pickerView(YearPicker, didSelectRow: 0, inComponent: 0)
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
        
        btnDone?.clipsToBounds = true
        btnDone?.layer.cornerRadius = (btnDone?.frame.size.height)!/2
        
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = ""
        alertViewController.message = "Do you have an insurance policy?"
        
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
                
                self.boolIsHavingInsurancePolicy = true
                self.mainTableView?.reloadData()
        })
        
        // Add alert actions
        let cancelAction = NYAlertAction(
            title: "No",
            style: .cancel,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController?.dismiss(animated: true, completion: nil)
                
                self.boolIsHavingInsurancePolicy = false
                
                self.mainHeaderTwoContainerView?.autoresizesSubviews = false
                
                self.lblPolicyNumber?.isHidden = true
                self.txtPolicyNumber?.isHidden = true
                self.txtPolicyNumberBottomSeparatorView?.isHidden = true
                
                self.lblYearOfMenufacture?.frame.origin.y = (self.lblPolicyNumber?.frame.origin.y)!
                self.txtYearOfMenufacture?.frame.origin.y = (self.txtPolicyNumber?.frame.origin.y)!
                self.txtYearOfMenufactureBottomSeparatorView?.frame.origin.y = (self.txtPolicyNumberBottomSeparatorView?.frame.origin.y)!
                
                self.mainHeaderTwoContainerView?.frame.size.height = (self.txtYearOfMenufactureBottomSeparatorView?.frame.origin.y)! + (self.txtYearOfMenufactureBottomSeparatorView?.frame.size.height)! + 10
                
                self.mainHeaderTwoContainerView?.autoresizesSubviews = true
                    
                self.mainTableView?.reloadData()
        })
        
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancelAction)
        
        self.navigationController?.present(alertViewController, animated: true, completion: nil)
        
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "INSURANCE RENEWAL"
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
                selector: #selector(self.user_renewed_insuranceEvent),
                name: Notification.Name("user_renewed_insuranceEvent"),
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
            
            self.datarows = dataManager.arrayAllMyCars
            if (self.datarows.count > 0)
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
    
    @objc func user_renewed_insuranceEvent()
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
        
        lblInsurance?.font = lblFont
        lblInsurance?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblInsurance?.textAlignment = .left
        
        lblRenewal?.font = lblServiceFont
        lblRenewal?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblRenewal?.textAlignment = .left
        
        // SELECT INSURANCE COMPANY
        lblChooseInsuranceCompany?.font = lblFont
        lblChooseInsuranceCompany?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblChooseInsuranceCompany?.textAlignment = .left
        
        txtChooseInsuranceCompany?.font = txtFont
        txtChooseInsuranceCompany?.delegate = self
        txtChooseInsuranceCompany?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseInsuranceCompany?.attributedPlaceholder = NSAttributedString(string: "Select insurance company",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtChooseInsuranceCompany?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseInsuranceCompany?.textAlignment = .left
        txtChooseInsuranceCompany?.autocorrectionType = UITextAutocorrectionType.no
        
        txtChooseInsuranceCompanyBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        InsuranceCompanyPicker = UIPickerView()
        InsuranceCompanyPicker.delegate = self
        InsuranceCompanyPicker.dataSource = self
        txtChooseInsuranceCompany?.inputView = InsuranceCompanyPicker
        
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
        
        // POLICY NUMBER
        lblPolicyNumber?.font = lblFont
        lblPolicyNumber?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblPolicyNumber?.textAlignment = .left
        
        txtPolicyNumber?.font = txtFont
        txtPolicyNumber?.delegate = self
        txtPolicyNumber?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtPolicyNumber?.attributedPlaceholder = NSAttributedString(string: "Enter policy number",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtPolicyNumber?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtPolicyNumber?.textAlignment = .left
        txtPolicyNumber?.autocorrectionType = UITextAutocorrectionType.no
        
        txtPolicyNumberBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // SELECT DATE
        lblExpiryDate?.font = lblFont
        lblExpiryDate?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblExpiryDate?.textAlignment = .left
        
        txtExpiryDate?.font = txtFont
        txtExpiryDate?.delegate = self
        txtExpiryDate?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtExpiryDate?.attributedPlaceholder = NSAttributedString(string: "Select insurance expiry date",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtExpiryDate?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtExpiryDate?.textAlignment = .left
        txtExpiryDate?.autocorrectionType = UITextAutocorrectionType.no
        
        txtExpiryDateBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        txtExpiryDate!.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        
        // CHOOSE YEAR OF MANUFACTUR
        lblYearOfMenufacture?.font = lblFont
        lblYearOfMenufacture?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblYearOfMenufacture?.textAlignment = .left
        
        txtYearOfMenufacture?.font = txtFont
        txtYearOfMenufacture?.delegate = self
        txtYearOfMenufacture?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtYearOfMenufacture?.attributedPlaceholder = NSAttributedString(string: "Select year of manufacture",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtYearOfMenufacture?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtYearOfMenufacture?.textAlignment = .left
        txtYearOfMenufacture?.autocorrectionType = UITextAutocorrectionType.no
        
        txtYearOfMenufactureBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        YearPicker = UIPickerView()
        YearPicker.delegate = self
        YearPicker.dataSource = self
        txtYearOfMenufacture?.inputView = YearPicker
        
        // DONE
        btnDone?.titleLabel?.font = txtFont
        btnDone?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnDone?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnDone?.addTarget(self, action: #selector(self.btnDoneClicked(_:)), for: .touchUpInside)
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = UIColor.clear
        mainTableView?.isHidden = false
        
        // API CALL
        dataManager.user_get_my_car_list()
    }
    
    // MARK: - Other Methods
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txtExpiryDate!.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func btnDoneClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((txtChooseInsuranceCompany?.text?.count)! <= 0 || (txtChooseYourCar?.text?.count)! <= 0)
        {
            if (txtChooseInsuranceCompany?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select insurance company.")
            }
            else if (txtChooseYourCar?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select your car.")
            }
        }
        else
        {
            if (self.boolIsHavingInsurancePolicy == true)
            {
                if ((txtPolicyNumber?.text?.count)! <= 0 || (txtExpiryDate?.text?.count)! <= 0)
                {
                    if (txtPolicyNumber?.text?.count)! <= 0
                    {
                        appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter policy number.")
                    }
                    else if (txtExpiryDate?.text?.count)! <= 0
                    {
                        appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select policy expiry date.")
                    }
                }
                else
                {
                    let alertViewController = NYAlertViewController()
                    
                    // Set a title and message
                    alertViewController.title = ""
                    alertViewController.message = "Are you sure you want to renew this insurance?"
                    
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
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .medium
                            dateFormatter.timeStyle = .none
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let strDate = dateFormatter.string(from: self.datePickerView.date)
                            
                            //API CALL
                            dataManager.user_renew_insurance(strInsuranceCompanyID: (self.objSelectedInsuranceCompany?.strInsuranceCompanyID)!, strCarID: (self.objSelectedCar?.strCarID)!, strPolicyNumber: (self.txtPolicyNumber?.text)!, strExpiryDate: strDate, strYearOfMenufactury: (self.txtYearOfMenufacture?.text)!)
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
            else
            {
                let alertViewController = NYAlertViewController()
                
                // Set a title and message
                alertViewController.title = ""
                alertViewController.message = "Are you sure you want to buy insurance?"
                
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
                        dataManager.user_renew_insurance(strInsuranceCompanyID: (self.objSelectedInsuranceCompany?.strInsuranceCompanyID)!, strCarID: (self.objSelectedCar?.strCarID)!, strPolicyNumber: "", strExpiryDate: "", strYearOfMenufactury: (self.txtYearOfMenufacture?.text)!)
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
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0)
        {
            return (mainHeaderContainerView?.frame.size.height)!
        }
        else if (section == 1)
        {
            return (mainHeaderTwoContainerView?.frame.size.height)!
        }
        else
        {
            return (mainHeaderThreeContainerView?.frame.size.height)!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if (section == 0)
        {
            return (mainHeaderContainerView)!
        }
        else if (section == 1)
        {
            return (mainHeaderTwoContainerView)!
        }
        else
        {
            return (mainHeaderThreeContainerView)!
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
    
    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == CarPicker
        {
            return datarows.count
        }
        else if pickerView == InsuranceCompanyPicker
        {
            return datarowsInsuranceCompany.count
        }
        else
        {
            return datarowsYears.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == CarPicker
        {
            return "\(datarows[row].strModelName) - \(datarows[row].strRegistrationNumber)"
        }
        else if pickerView == InsuranceCompanyPicker
        {
            return datarowsInsuranceCompany[row].strInsuranceCompanyName
        }
        else
        {
            return datarowsYears[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == CarPicker
        {
            txtChooseYourCar?.text = "\(datarows[row].strModelName) - \(datarows[row].strRegistrationNumber)" 
            self.objSelectedCar = datarows[row]
        }
        else if pickerView == InsuranceCompanyPicker
        {
            txtChooseInsuranceCompany?.text = datarowsInsuranceCompany[row].strInsuranceCompanyName
            self.objSelectedInsuranceCompany = datarowsInsuranceCompany[row]
        }
        else
        {
            txtYearOfMenufacture?.text = datarowsYears[row]
        }
    }
    
    
    // MARK: - UITextField Delagate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == txtChooseYourCar)
        {
            if (self.datarows.count > 0)
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
