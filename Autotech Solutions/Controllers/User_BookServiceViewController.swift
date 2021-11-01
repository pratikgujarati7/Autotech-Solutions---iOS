//
//  User_BookServiceViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 07/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift
import GoogleMaps
import CoreLocation

class User_BookServiceViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, GMSMapViewDelegate, CLLocationManagerDelegate
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
    @IBOutlet var lblBook: UILabel?
    @IBOutlet var lblService: UILabel?
    
    //HEADER TWO
    @IBOutlet var mainHeaderTwoContainerView: UIView?
    @IBOutlet var lblChooseYourCar: UILabel?
    @IBOutlet var txtChooseYourCar: UITextField?
    @IBOutlet var txtChooseYourCarBottomSeparatorView: UIView?
    
    @IBOutlet var lblSelectBranch: UILabel?
    @IBOutlet var txtSelectBranch: UITextField?
    @IBOutlet var txtSelectBranchBottomSeparatorView: UIView?
    
    @IBOutlet var lblServiceDate: UILabel?
    @IBOutlet var txtServiceDate: UITextField?
    @IBOutlet var txtServiceDateBottomSeparatorView: UIView?
    
    @IBOutlet var lblRechability: UILabel?
    @IBOutlet var btnSelfServiceContainerView: UIView?
    @IBOutlet var imageViewSelfService: UIImageView?
    @IBOutlet var lblSelfService: UILabel?
    @IBOutlet var btnSelfService: UIButton?
    @IBOutlet var lblRechabilityBottomSeparatorView: UIView?
    
    @IBOutlet var btnPickUpDropContainerView: UIView?
    @IBOutlet var imageViewPickUpDrop: UIImageView?
    @IBOutlet var lblPickUpDrop: UILabel?
    @IBOutlet var btnPickUpDrop: UIButton?
    
    //HEADER THREE
    @IBOutlet var mainHeaderThreeContainerView: UIView?
    
    @IBOutlet var lblSelectPickupTime: UILabel?
    @IBOutlet var txtSelectPickupTime: UITextField?
    @IBOutlet var txtSelectPickupTimeBottomSeparatorView: UIView?
    
    @IBOutlet var btnAddressBookContainerView: UIView?
    @IBOutlet var imageViewAddressBook: UIImageView?
    @IBOutlet var btnAddressBook: UIButton?
    
    @IBOutlet var btnLocationContainerView: UIView?
    @IBOutlet var imageViewLocation: UIImageView?
    @IBOutlet var btnLocation: UIButton?
    
    @IBOutlet var lblLocation: UILabel?
    @IBOutlet var txtViewLocation: UITextView?
    
    //HEADER FOUR
    @IBOutlet var mainHeaderFourContainerView: UIView?
    @IBOutlet var btnBookMyService: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarows = [ObjCar]()
    var objSelectedCar: ObjCar?
    
    var datarowsBranch = [ObjBranch]()
    var objSelectedBranch: ObjBranch?
    
    var CarPicker : UIPickerView = UIPickerView()
    var BranchPicker : UIPickerView = UIPickerView()
    let datePickerView:UIDatePicker = UIDatePicker()
    let timePickerView:UIDatePicker = UIDatePicker()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentAddress : String = ""
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNotificationEvent()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        datarowsBranch = dataManager.arrayAllBranches
        BranchPicker.reloadAllComponents()
        self.pickerView(BranchPicker, didSelectRow: 0, inComponent: 0)
        self.datePickerView.date = Date()
        self.datePickerValueChanged(sender: self.datePickerView)
        
        // GET CURRENT LAT LONG
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return
            }
            
            //currentLocation.coordinate.latitude
            //currentLocation.coordinate.longitude
            
            // REVERSE GEO CODE
            let geocoder = GMSGeocoder()
            currentAddress = String()
            geocoder.reverseGeocodeCoordinate(currentLocation.coordinate) { response , error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    
                    self.currentAddress = lines.joined(separator: ", ")
                    
                    self.txtViewLocation?.text = self.currentAddress
                    
                    NSLog("\(self.currentAddress)")
                }
            }
        }
        else
        {
            
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            // REVERSE GEO CODE
            let geocoder = GMSGeocoder()
            currentAddress = String()
            geocoder.reverseGeocodeCoordinate(currentLocation.coordinate) { response , error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    
                    self.currentAddress = lines.joined(separator: ", ")
                    
                    self.txtViewLocation?.text = self.currentAddress
                    
                    NSLog("\(self.currentAddress)")
                }
            }
        }
        else
        {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.txtViewLocation?.text = dataManager.currentAddress
        
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
        
        btnBookMyService?.clipsToBounds = true
        btnBookMyService?.layer.cornerRadius = (btnBookMyService?.frame.size.height)!/2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewMenu?.layer.masksToBounds = true
        btnMenu?.addTarget(self, action: #selector(self.btnMenuClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "BOOK A SERVICE"
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
                selector: #selector(self.user_booked_serviceEvent),
                name: Notification.Name("user_booked_serviceEvent"),
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
    
    @objc func user_booked_serviceEvent()
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
        
        lblBook?.font = lblFont
        lblBook?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblBook?.textAlignment = .left
        
        lblService?.font = lblServiceFont
        lblService?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblService?.textAlignment = .left
        
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
        
        // SELECT BRANCH
        lblSelectBranch?.font = lblFont
        lblSelectBranch?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblSelectBranch?.textAlignment = .left
        
        txtSelectBranch?.font = txtFont
        txtSelectBranch?.delegate = self
        txtSelectBranch?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtSelectBranch?.attributedPlaceholder = NSAttributedString(string: "Select branch",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtSelectBranch?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtSelectBranch?.textAlignment = .left
        txtSelectBranch?.autocorrectionType = UITextAutocorrectionType.no
        
        txtSelectBranchBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        BranchPicker = UIPickerView()
        BranchPicker.delegate = self
        BranchPicker.dataSource = self
        txtSelectBranch?.inputView = BranchPicker
        
        // SELECT DATE
        lblServiceDate?.font = lblFont
        lblServiceDate?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblServiceDate?.textAlignment = .left
        
        txtServiceDate?.font = txtFont
        txtServiceDate?.delegate = self
        txtServiceDate?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtServiceDate?.attributedPlaceholder = NSAttributedString(string: "Select service date",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtServiceDate?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtServiceDate?.textAlignment = .left
        txtServiceDate?.autocorrectionType = UITextAutocorrectionType.no
        
        txtServiceDateBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        txtServiceDate!.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        
        // RECHABILITY
        lblRechability?.font = lblFont
        lblRechability?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblRechability?.textAlignment = .left
        lblRechabilityBottomSeparatorView?.backgroundColor =  MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        // SELF DRIVEN
        imageViewSelfService?.contentMode = .scaleAspectFit
        lblSelfService?.font = lblFont
        lblSelfService?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblSelfService?.textAlignment = .left
        btnSelfService?.tintColor = .clear
        btnSelfService?.addTarget(self, action: #selector(self.btnRadioClicked(_:)), for: .touchUpInside)
        
        // PICK UP DROP
        imageViewPickUpDrop?.contentMode = .scaleAspectFit
        lblPickUpDrop?.font = lblFont
        lblPickUpDrop?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblPickUpDrop?.textAlignment = .left
        btnPickUpDrop?.tintColor = .clear
        btnPickUpDrop?.addTarget(self, action: #selector(self.btnRadioClicked(_:)), for: .touchUpInside)
        
        // LOCATION
        lblLocation?.font = lblFont
        lblLocation?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblLocation?.textAlignment = .left
        
        btnAddressBook?.addTarget(self, action: #selector(self.btnAddressBookClicked(_:)), for: .touchUpInside)
        
        btnLocation?.addTarget(self, action: #selector(self.btnLocationClicked(_:)), for: .touchUpInside)
        
        txtViewLocation?.font = txtFont
        txtViewLocation?.delegate = self
        txtViewLocation?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtViewLocation?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtViewLocation?.textAlignment = .left
        txtViewLocation?.autocorrectionType = UITextAutocorrectionType.no
        txtViewLocation?.layer.borderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor?.cgColor
        txtViewLocation?.layer.borderWidth = 1
        txtViewLocation?.clipsToBounds = true
        txtViewLocation?.layer.cornerRadius = 5
        
        // SELECT TIME
        lblSelectPickupTime?.font = lblFont
        lblSelectPickupTime?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblSelectPickupTime?.textAlignment = .left
        
        txtSelectPickupTime?.font = txtFont
        txtSelectPickupTime?.delegate = self
        txtSelectPickupTime?.tintColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtSelectPickupTime?.attributedPlaceholder = NSAttributedString(string: "Select pickup time",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtSelectPickupTime?.textColor = MySingleton.sharedManager() .themeGlobalRedColor
        txtSelectPickupTime?.textAlignment = .left
        txtSelectPickupTime?.autocorrectionType = UITextAutocorrectionType.no
        
        txtSelectPickupTimeBottomSeparatorView?.backgroundColor = MySingleton.sharedManager() .themeGlobalRedColor?.withAlphaComponent(0.5)
        
        timePickerView.datePickerMode = .time
        //timePickerView.minimumDate =
        txtSelectPickupTime!.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        
        // BOOOK SERVICE
        btnBookMyService?.titleLabel?.font = txtFont
        btnBookMyService?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnBookMyService?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnBookMyService?.addTarget(self, action: #selector(self.btnBookMyServiceClicked(_:)), for: .touchUpInside)
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = UIColor.clear
        mainTableView?.isHidden = false
        
        // PICKUP DROP SELECTED
        self.btnRadioClicked(btnPickUpDrop!)
        // API CALL
        dataManager.user_get_my_car_list()
    }
    
    // MARK: - Other Methods
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        if (sender == datePickerView)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtServiceDate!.text = dateFormatter.string(from: sender.date)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "hh:mm a"
            txtSelectPickupTime!.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    @IBAction func btnRadioClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (sender == btnSelfService)
        {
            btnSelfService?.isSelected = true
            imageViewSelfService?.image = UIImage(named: "radio_selected.png")
            btnPickUpDrop?.isSelected = false
            imageViewPickUpDrop?.image = UIImage(named: "radio_normal.png")
            lblSelfService?.textColor = MySingleton.sharedManager().themeGlobalRedColor
            lblPickUpDrop?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
            lblRechabilityBottomSeparatorView?.isHidden = true
        }
        else
        {
            btnSelfService?.isSelected = false
            imageViewSelfService?.image = UIImage(named: "radio_normal.png")
            btnPickUpDrop?.isSelected = true
            imageViewPickUpDrop?.image = UIImage(named: "radio_selected.png")
            lblSelfService?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
            lblPickUpDrop?.textColor = MySingleton.sharedManager().themeGlobalRedColor
            lblRechabilityBottomSeparatorView?.isHidden = false
        }
        mainTableView?.reloadData()
    }
    
    @IBAction func btnAddressBookClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController : User_MyAddressListViewController = User_MyAddressListViewController()
        viewController.boolIsForSelection = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnLocationClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController : User_PickLocationViewController = User_PickLocationViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnBookMyServiceClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((txtChooseYourCar?.text?.count)! <= 0 || (txtSelectBranch?.text?.count)! <= 0 || (txtServiceDate?.text?.count)! <= 0)
        {
            if (txtChooseYourCar?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select your car.")
            }
            else if (txtSelectBranch?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please selectbranch.")
            }
            else if (txtServiceDate?.text?.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select service date.")
            }
        }
        else if (btnPickUpDrop?.isSelected == true && (txtViewLocation?.text.count)! <= 0 && (txtSelectPickupTime?.text!.count)! <= 0)
        {
            if (txtViewLocation?.text.count)! <= 0
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter your address.")
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select pickup time.")
            }
        }
        else
        {
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Are you sure you want to book service?"
            
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
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let strDate = dateFormatter.string(from: self.datePickerView.date)
                    
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateStyle = .medium
                    dateFormatter2.timeStyle = .none
                    dateFormatter2.dateFormat = "HH:mm"
                    let strTime = dateFormatter2.string(from: self.timePickerView.date)
                    
                    if ((self.btnSelfService?.isSelected)!)
                    {
                        //API CALL
                        dataManager.user_book_service(strCarID: (self.objSelectedCar?.strCarID)!, strBranchID: (self.objSelectedBranch?.strBranchID)! , strServiceDate: strDate, strRechability: "1", strLocation: "", strPickupTime: "", strLattitude: "0", strLongitude: "0")
                    }
                    else
                    {
                        if (dataManager.currentLocation != nil)
                        {
                            //API CALL
                            dataManager.user_book_service(strCarID: (self.objSelectedCar?.strCarID)!, strBranchID: (self.objSelectedBranch?.strBranchID)! , strServiceDate: strDate, strRechability: "0", strLocation: (self.txtViewLocation?.text)!, strPickupTime: strTime, strLattitude: "\(dataManager.currentLocation.coordinate.latitude)", strLongitude: "\(dataManager.currentLocation.coordinate.longitude)")
                        }
                        else
                        {
                            //API CALL
                            dataManager.user_book_service(strCarID: (self.objSelectedCar?.strCarID)!, strBranchID: (self.objSelectedBranch?.strBranchID)! , strServiceDate: strDate, strRechability: "0", strLocation: (self.txtViewLocation?.text)!, strPickupTime: strTime, strLattitude: "0", strLongitude: "0")
                        }
                    }
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
        return 4
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
        else if (section == 2)
        {
            if ((btnSelfService?.isSelected)!)
            {
                return 0
            }
            else
            {
                return (mainHeaderThreeContainerView?.frame.size.height)!
            }
        }
        else
        {
            return (mainHeaderFourContainerView?.frame.size.height)!
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
        else if (section == 2)
        {
            if ((btnSelfService?.isSelected)!)
            {
                return nil
            }
            else
            {
                return (mainHeaderThreeContainerView)!
            }
        }
        else
        {
            return (mainHeaderFourContainerView)!
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
        else
        {
            return datarowsBranch.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == CarPicker
        {
            return "\(datarows[row].strModelName) - \(datarows[row].strRegistrationNumber)"
        }
        else
        {
            return datarowsBranch[row].strBranchName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == CarPicker
        {
            txtChooseYourCar?.text = "\(datarows[row].strModelName) - \(datarows[row].strRegistrationNumber)"
            self.objSelectedCar = datarows[row]
        }
        else
        {
            txtSelectBranch?.text = datarowsBranch[row].strBranchName
            self.objSelectedBranch = datarowsBranch[row]
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
        else if (textField == txtSelectPickupTime)
        {
            if (textField.text == "")
            {
                timePickerView.date = Date()
                datePickerValueChanged(sender: timePickerView)
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
