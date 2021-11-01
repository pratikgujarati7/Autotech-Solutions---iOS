//
//  User_MyCarsViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 29/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
import NYAlertViewController
import IQKeyboardManagerSwift

class User_MyCarsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource
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
    
    //MAIN HEADER
    @IBOutlet var mainHeaderContainerView: UIView?
    @IBOutlet var mainHeaderBackgroundImageView: UIImageView?
    @IBOutlet var lblExplore: UILabel?
    @IBOutlet var lblBrandName: UILabel?
    @IBOutlet var lblCompanyName: UILabel?
    @IBOutlet var lblAddCarDetails: UILabel?
    //MY CARS
    @IBOutlet var btnMyCarsContainerView: UIView?
    @IBOutlet var imageViewMyCars: UIImageView?
    @IBOutlet var lblMyCars: UILabel?
    @IBOutlet var btnMyCarsBottomSeparatorView: UIView?
    @IBOutlet var btnMyCars: UIButton?
    //ADD CARS
    @IBOutlet var btnAddCarsContainerView: UIView?
    @IBOutlet var imageViewAddCars: UIImageView?
    @IBOutlet var lblAddCars: UILabel?
    @IBOutlet var btnAddCarsBottomSeparatorView: UIView?
    @IBOutlet var btnAddCars: UIButton?
    //MAIN HEADE TITLE
    @IBOutlet var lblMainHeaderTitle: UILabel?
    
    //ADD CAR HEADR
    @IBOutlet var addCarsDetailsContainerView: UIView?
    
    @IBOutlet var txtChooseCompanyContainerView: UIView?
    @IBOutlet var lblChooseCompany: UILabel?
    @IBOutlet var txtChooseCompany: UITextField?
    
    @IBOutlet var txtChooseModelContainerView: UIView?
    @IBOutlet var lblChooseModel: UILabel?
    @IBOutlet var txtChooseModel: UITextField?
    
    @IBOutlet var txtRegistrationNumerContainerView: UIView?
    @IBOutlet var lblRegistrationNumer: UILabel?
    @IBOutlet var txtRegistrationNumerOne: UITextField?
    @IBOutlet var txtRegistrationNumerTwo: UITextField?
    @IBOutlet var txtRegistrationNumerThree: UITextField?
    @IBOutlet var txtRegistrationNumerFour: UITextField?
    @IBOutlet var txtRegistrationNumerFive: UITextField?
    @IBOutlet var txtRegistrationNumerSix: UITextField?
    @IBOutlet var txtRegistrationNumerSeven: UITextField?
    @IBOutlet var txtRegistrationNumerEight: UITextField?
    @IBOutlet var txtRegistrationNumerNine: UITextField?
    @IBOutlet var txtRegistrationNumerTen: UITextField?
    
    @IBOutlet var txtChooseFualTypeContainerView: UIView?
    @IBOutlet var lblChooseFualType: UILabel?
    @IBOutlet var txtChooseFualType: UITextField?
    
    @IBOutlet var btnSaveCars: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarows = [ObjCar]()
    
    var CompanyPicker : UIPickerView = UIPickerView()
    var ModelPicker : UIPickerView = UIPickerView()
    var FualTypePicker : UIPickerView = UIPickerView()
    
    var datarowsMake = [ObjMake]()
    var datarowsFualType = [ObjFualType]()
    
    var objSelectedMake: ObjMake?
    var objSelectedModel: ObjModel?
    var objSelectedFualType: ObjFualType?
    
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
        
        txtRegistrationNumerOne?.clipsToBounds = true
        txtRegistrationNumerOne?.layer.cornerRadius = 5
        
        txtRegistrationNumerTwo?.clipsToBounds = true
        txtRegistrationNumerTwo?.layer.cornerRadius = 5
        
        txtRegistrationNumerThree?.clipsToBounds = true
        txtRegistrationNumerThree?.layer.cornerRadius = 5
        
        txtRegistrationNumerFour?.clipsToBounds = true
        txtRegistrationNumerFour?.layer.cornerRadius = 5
        
        txtRegistrationNumerFive?.clipsToBounds = true
        txtRegistrationNumerFive?.layer.cornerRadius = 5
        
        txtRegistrationNumerSix?.clipsToBounds = true
        txtRegistrationNumerSix?.layer.cornerRadius = 5
        
        txtRegistrationNumerSeven?.clipsToBounds = true
        txtRegistrationNumerSeven?.layer.cornerRadius = 5
        
        txtRegistrationNumerEight?.clipsToBounds = true
        txtRegistrationNumerEight?.layer.cornerRadius = 5
        
        txtRegistrationNumerNine?.clipsToBounds = true
        txtRegistrationNumerNine?.layer.cornerRadius = 5
        
        txtRegistrationNumerTen?.clipsToBounds = true
        txtRegistrationNumerTen?.layer.cornerRadius = 5
        
        
        btnSaveCars?.clipsToBounds = true
        btnSaveCars?.layer.cornerRadius = (btnSaveCars?.frame.size.height)!/2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewBack?.layer.masksToBounds = true
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "MY CARS"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
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
                selector: #selector(self.user_got_my_car_listEvent),
                name: Notification.Name("user_got_my_car_listEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_added_carEvent),
                name: Notification.Name("user_added_carEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_deleted_carEvent),
                name: Notification.Name("user_deleted_carEvent"),
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
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_deleted_carEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.btnMyCarsClicked(self.btnMyCars!)
            
        })
    }
    
    @objc func user_added_carEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.txtRegistrationNumerOne?.text = ""
            self.txtRegistrationNumerTwo?.text = ""
            self.txtRegistrationNumerThree?.text = ""
            self.txtRegistrationNumerFour?.text = ""
            self.txtRegistrationNumerFive?.text = ""
            self.txtRegistrationNumerSix?.text = ""
            self.txtRegistrationNumerSeven?.text = ""
            self.txtRegistrationNumerEight?.text = ""
            self.txtRegistrationNumerNine?.text = ""
            self.txtRegistrationNumerTen?.text = ""
            
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
                    
                    self.btnMyCarsClicked(self.btnMyCars!)
                    self.navigationController!.dismiss(animated: true, completion: nil)
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
        
        var lblBrandNameFont, txtTitleFont, lblFont, btnTitleFont, txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            lblBrandNameFont = MySingleton.sharedManager().themeFontTwentySizeBold
            txtTitleFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontTwelveSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            lblBrandNameFont = MySingleton.sharedManager().themeFontTwentyOneSizeBold
            txtTitleFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontThirteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
        }
        else
        {
            lblBrandNameFont = MySingleton.sharedManager().themeFontTwentyTwoSizeBold
            txtTitleFont = MySingleton.sharedManager().themeFontSeventeenSizeRegular
            lblFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            btnTitleFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            txtFont = MySingleton.sharedManager().themeFontEighteenSizeRegular
        }
        
        lblExplore?.font = lblFont
        lblExplore?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblExplore?.textAlignment = .left
        
        lblBrandName?.font = lblBrandNameFont
        lblBrandName?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblBrandName?.textAlignment = .left
        
        lblCompanyName?.font = lblFont
        lblCompanyName?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblCompanyName?.textAlignment = .left
        
        lblAddCarDetails?.font = lblFont
        lblAddCarDetails?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblAddCarDetails?.textAlignment = .left
        
        //MY CARS
        imageViewMyCars?.layer.masksToBounds = true
        lblMyCars?.font = lblFont
        lblMyCars?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblMyCars?.textAlignment = .center
        btnMyCars?.addTarget(self, action: #selector(self.btnMyCarsClicked(_:)), for: .touchUpInside)
        btnMyCarsBottomSeparatorView?.isHidden = false
        
        //ADD CARS
        imageViewAddCars?.layer.masksToBounds = true
        lblAddCars?.font = lblFont
        lblAddCars?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblAddCars?.textAlignment = .center
        btnAddCars?.addTarget(self, action: #selector(self.btnAddCarsClicked(_:)), for: .touchUpInside)
        btnAddCarsBottomSeparatorView?.isHidden = true
        
        //ADD CAR DETAILS HEADER
        // COMPANY
        lblChooseCompany?.font = lblFont
        lblChooseCompany?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblChooseCompany?.textAlignment = .left
        
        txtChooseCompany?.font = txtFont
        txtChooseCompany?.delegate = self
        txtChooseCompany?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseCompany?.attributedPlaceholder = NSAttributedString(string: "Select your car company",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtChooseCompany?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseCompany?.textAlignment = .left
        txtChooseCompany?.autocorrectionType = UITextAutocorrectionType.no
        
        CompanyPicker = UIPickerView()
        CompanyPicker.delegate = self
        CompanyPicker.dataSource = self
        txtChooseCompany?.inputView = CompanyPicker
        
        // MODEL
        lblChooseModel?.font = lblFont
        lblChooseModel?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblChooseModel?.textAlignment = .left
        
        txtChooseModel?.font = txtFont
        txtChooseModel?.delegate = self
        txtChooseModel?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseModel?.attributedPlaceholder = NSAttributedString(string: "Select your car model",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtChooseModel?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseModel?.textAlignment = .left
        txtChooseModel?.autocorrectionType = UITextAutocorrectionType.no
        
        ModelPicker = UIPickerView()
        ModelPicker.delegate = self
        ModelPicker.dataSource = self
        txtChooseModel?.inputView = ModelPicker
        
        // REGISTRATION NUMBER
        lblRegistrationNumer?.font = lblFont
        lblRegistrationNumer?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblRegistrationNumer?.textAlignment = .left
        
        txtRegistrationNumerOne?.delegate = self
        txtRegistrationNumerOne?.font = txtFont
        txtRegistrationNumerOne?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerOne?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerOne?.textAlignment = .center
        txtRegistrationNumerOne?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerOne?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerTwo?.delegate = self
        txtRegistrationNumerTwo?.font = txtFont
        txtRegistrationNumerTwo?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerTwo?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerTwo?.textAlignment = .center
        txtRegistrationNumerTwo?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerTwo?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerThree?.delegate = self
        txtRegistrationNumerThree?.font = txtFont
        txtRegistrationNumerThree?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerThree?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerThree?.textAlignment = .center
        txtRegistrationNumerThree?.keyboardType = .numberPad
        txtRegistrationNumerThree?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerThree?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerFour?.delegate = self
        txtRegistrationNumerFour?.font = txtFont
        txtRegistrationNumerFour?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerFour?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerFour?.textAlignment = .center
        txtRegistrationNumerFour?.keyboardType = .numberPad
        txtRegistrationNumerFour?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerFour?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerFive?.delegate = self
        txtRegistrationNumerFive?.font = txtFont
        txtRegistrationNumerFive?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerFive?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerFive?.textAlignment = .center
        txtRegistrationNumerFive?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerFive?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerSix?.delegate = self
        txtRegistrationNumerSix?.font = txtFont
        txtRegistrationNumerSix?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerSix?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerSix?.textAlignment = .center
        txtRegistrationNumerSix?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerSix?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerSeven?.delegate = self
        txtRegistrationNumerSeven?.font = txtFont
        txtRegistrationNumerSeven?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerSeven?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerSeven?.textAlignment = .center
        txtRegistrationNumerSeven?.keyboardType = .numberPad
        txtRegistrationNumerSeven?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerSeven?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerEight?.delegate = self
        txtRegistrationNumerEight?.font = txtFont
        txtRegistrationNumerEight?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerEight?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerEight?.textAlignment = .center
        txtRegistrationNumerEight?.keyboardType = .numberPad
        txtRegistrationNumerEight?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerEight?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerNine?.delegate = self
        txtRegistrationNumerNine?.font = txtFont
        txtRegistrationNumerNine?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerNine?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerNine?.textAlignment = .center
        txtRegistrationNumerNine?.keyboardType = .numberPad
        txtRegistrationNumerNine?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerNine?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        txtRegistrationNumerTen?.delegate = self
        txtRegistrationNumerTen?.font = txtFont
        txtRegistrationNumerTen?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        txtRegistrationNumerTen?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtRegistrationNumerTen?.textAlignment = .center
        txtRegistrationNumerTen?.keyboardType = .numberPad
        txtRegistrationNumerTen?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtRegistrationNumerTen?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        // FUAL TYPE
        lblChooseFualType?.font = lblFont
        lblChooseFualType?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblChooseFualType?.textAlignment = .left
        
        txtChooseFualType?.font = txtFont
        txtChooseFualType?.delegate = self
        txtChooseFualType?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseFualType?.attributedPlaceholder = NSAttributedString(string: "Select Fuel type",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtChooseFualType?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtChooseFualType?.textAlignment = .left
        txtChooseFualType?.autocorrectionType = UITextAutocorrectionType.no
        
        FualTypePicker = UIPickerView()
        FualTypePicker.delegate = self
        FualTypePicker.dataSource = self
        txtChooseFualType?.inputView = FualTypePicker
        
        btnSaveCars?.titleLabel?.font = txtFont
        btnSaveCars?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnSaveCars?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnSaveCars?.addTarget(self, action: #selector(self.btnSaveCarsClicked(_:)), for: .touchUpInside)
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = UIColor.clear
        mainTableView?.isHidden = false
        
        // API CALL
        dataManager.user_get_my_car_list()
    }
    
    @IBAction func btnMyCarsClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        btnMyCarsBottomSeparatorView?.isHidden = false
        btnAddCarsBottomSeparatorView?.isHidden = true
        lblMainHeaderTitle?.text = "Your Car List"
        
        // API CALL
        dataManager.user_get_my_car_list()
    }
    
    @IBAction func btnAddCarsClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        datarowsMake = dataManager.arrayAllMakes
        CompanyPicker.selectRow(0, inComponent: 0, animated: false)
        self.pickerView(CompanyPicker, didSelectRow: 0, inComponent: 0)
        
        datarowsFualType = dataManager.arrayAllFualType
        FualTypePicker.selectRow(0, inComponent: 0, animated: false)
        self.pickerView(FualTypePicker, didSelectRow: 0, inComponent: 0)
        
        
        
        btnMyCarsBottomSeparatorView?.isHidden = true
        btnAddCarsBottomSeparatorView?.isHidden = false
        lblMainHeaderTitle?.text = "Fill Your Car Details"
        mainTableView?.reloadData()
    }
    
    @IBAction func btnSaveCarsClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((txtChooseCompany?.text?.count)! <= 0 || (txtChooseModel?.text?.count)! <= 0 || (txtRegistrationNumerOne?.text?.count)! <= 0 || (txtRegistrationNumerTwo?.text?.count)! <= 0 || (txtRegistrationNumerThree?.text?.count)! <= 0 || (txtRegistrationNumerFour?.text?.count)! <= 0 || (txtRegistrationNumerFive?.text?.count)! <= 0 || (txtRegistrationNumerSix?.text?.count)! <= 0 || (txtRegistrationNumerSeven?.text?.count)! <= 0 || (txtRegistrationNumerEight?.text?.count)! <= 0 || (txtRegistrationNumerNine?.text?.count)! <= 0 || (txtRegistrationNumerTen?.text?.count)! <= 0) || (txtChooseFualType?.text?.count)! <= 0
        {
            if (txtChooseCompany?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select your car company.")
            }
            else if (txtChooseModel?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select your car model.")
            }
            else if (txtChooseFualType?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select fuel type.")
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter your car registration number.")
            }
        }
        else
        {
            let strRegistrationNumber: String = String(format: "%@%@-%@%@-%@%@-%@%@%@%@", (txtRegistrationNumerOne?.text)!, (txtRegistrationNumerTwo?.text)!, (txtRegistrationNumerThree?.text)!, (txtRegistrationNumerFour?.text)!, (txtRegistrationNumerFive?.text)!, (txtRegistrationNumerSix?.text)!, (txtRegistrationNumerSeven?.text)!, (txtRegistrationNumerEight?.text)!, (txtRegistrationNumerNine?.text)!, (txtRegistrationNumerTen?.text)!)
            
            let strRNumberUpperCase = strRegistrationNumber.uppercased()
            
            //CALL WEB SERVICE
            dataManager.user_add_car(strMakeID: (objSelectedMake?.strMakeID)!, strModelID: (objSelectedModel?.strModelID)!, strRegistrationNumber: strRNumberUpperCase, strFualTypeID: (objSelectedFualType?.strFualTypeID)!)
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if btnMyCarsBottomSeparatorView?.isHidden == false
        {
            return 1
        }
        else
        {
            return 1
        }
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
        if btnMyCarsBottomSeparatorView?.isHidden == false
        {
            return 0
        }
        else
        {
            return (addCarsDetailsContainerView?.frame.size.height)!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if btnMyCarsBottomSeparatorView?.isHidden == false
        {
            return nil
        }
        else
        {
            return (addCarsDetailsContainerView)!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if btnMyCarsBottomSeparatorView?.isHidden == false
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
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (datarows.count > 0)
        {
            return MyCarTableViewCellHeight
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
            var cell:MyCarTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? MyCarTableViewCell
            
            if(cell == nil)
            {
                cell = MyCarTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            //COMPANY
            let str1Company: String = "Company : "
            let str2Company: String = "\(datarows[indexPath.row].strMakeName)"
            
            let attributeStringCompanyName: NSMutableAttributedString =  NSMutableAttributedString(string: str1Company + str2Company)
            
            attributeStringCompanyName.addAttribute(NSAttributedString.Key.foregroundColor, value: MySingleton.sharedManager().themeGlobalRedColor!, range: NSMakeRange(str1Company.count, str2Company.count))
            
            cell.lblCompanyName.attributedText = attributeStringCompanyName
            
            //MODEL
            let str1Model: String = "Car Model : "
            let str2Model: String = "\(datarows[indexPath.row].strModelName)"
            
            let attributeStringModelName: NSMutableAttributedString =  NSMutableAttributedString(string: str1Model + str2Model)
            
            attributeStringModelName.addAttribute(NSAttributedString.Key.foregroundColor, value: MySingleton.sharedManager().themeGlobalRedColor!, range: NSMakeRange(str1Model.count, str2Model.count))
            
            cell.lblCarModel.attributedText = attributeStringModelName
            
            //REGISTRATION NUMBER
            let str1Number: String = "Registration Number : "
            let str2Number: String = "\(datarows[indexPath.row].strRegistrationNumber)"
            
            let attributeStringNumber: NSMutableAttributedString =  NSMutableAttributedString(string: str1Number + str2Number)
            
            attributeStringNumber.addAttribute(NSAttributedString.Key.foregroundColor, value: MySingleton.sharedManager().themeGlobalRedColor!, range: NSMakeRange(str1Number.count, str2Number.count))
            
            cell.lblRegistrationNumber.attributedText = attributeStringNumber
            
            cell.lblCarID.text = String(format: "%02d", indexPath.row + 1)
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteClicked(_:)), for: .touchUpInside)
            
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
            lblNoData.text = "No cars found"
            
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
        alertViewController.message = "Are you sure you want to delete this car?"
        
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
                dataManager.user_delete_car(strCarID: self.datarows[sender.tag].strCarID)
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
        
    }
    
    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == CompanyPicker
        {
            return datarowsMake.count
        }
        else if pickerView == ModelPicker
        {
            return (objSelectedMake?.arrayAllModels.count)!
        }
        else
        {
            return datarowsFualType.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == CompanyPicker
        {
            return datarowsMake[row].strMakeName
        }
        else if pickerView == ModelPicker
        {
            return objSelectedMake?.arrayAllModels[row].strModelName
        }
        else
        {
            return datarowsFualType[row].strFualType
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == CompanyPicker
        {
            txtChooseCompany?.text = datarowsMake[row].strMakeName
            self.objSelectedMake = datarowsMake[row]
            ModelPicker.reloadAllComponents()
            ModelPicker.selectRow(0, inComponent: 0, animated: false)
            self.pickerView(ModelPicker, didSelectRow: 0, inComponent: 0)
        }
        else if pickerView == ModelPicker
        {
            txtChooseModel?.text = objSelectedMake?.arrayAllModels[row].strModelName
            objSelectedModel = objSelectedMake?.arrayAllModels[row]
        }
        else
        {
            txtChooseFualType?.text = datarowsFualType[row].strFualType
            self.objSelectedFualType = datarowsFualType[row]
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
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if (textField == txtRegistrationNumerOne || textField == txtRegistrationNumerTwo || textField == txtRegistrationNumerThree || textField == txtRegistrationNumerFour || textField == txtRegistrationNumerFive || textField == txtRegistrationNumerSix || textField == txtRegistrationNumerSeven || textField == txtRegistrationNumerEight || textField == txtRegistrationNumerNine || textField == txtRegistrationNumerTen)
        {
            if (textField.text?.count)! > 0
            {
                textField.text = ""
            }
        }
        
        return true
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField)
    {
        if sender == txtRegistrationNumerOne
        {
            sender.text = sender.text?.uppercased()
            
            if (txtRegistrationNumerOne?.text?.count)! > 0
            {
                txtRegistrationNumerTwo?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerTwo
        {
            sender.text = sender.text?.uppercased()
            
            if (txtRegistrationNumerTwo?.text?.count)! > 0
            {
                txtRegistrationNumerThree?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerThree
        {
            if (txtRegistrationNumerThree?.text?.count)! > 0
            {
                txtRegistrationNumerFour?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerFour
        {
            if (txtRegistrationNumerFour?.text?.count)! > 0
            {
                txtRegistrationNumerFive?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerFive
        {
            sender.text = sender.text?.uppercased()
            
            if (txtRegistrationNumerFive?.text?.count)! > 0
            {
                txtRegistrationNumerSix?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerSix
        {
            sender.text = sender.text?.uppercased()
            
            if (txtRegistrationNumerSix?.text?.count)! > 0
            {
                txtRegistrationNumerSeven?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerSeven
        {
            if (txtRegistrationNumerSeven?.text?.count)! > 0
            {
                txtRegistrationNumerEight?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerEight
        {
            if (txtRegistrationNumerEight?.text?.count)! > 0
            {
                txtRegistrationNumerNine?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerNine
        {
            if (txtRegistrationNumerNine?.text?.count)! > 0
            {
                txtRegistrationNumerTen?.becomeFirstResponder()
            }
        }
        if sender == txtRegistrationNumerTen
        {
            if (txtRegistrationNumerTen?.text?.count)! > 0
            {
                txtRegistrationNumerTen?.resignFirstResponder()
            }
        }
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
                navigationBarView?.backgroundColor = MySingleton.sharedManager().themeGlobalBlackColor
            }
        }
    }

}
