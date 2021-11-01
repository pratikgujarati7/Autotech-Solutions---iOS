//
//  User_CarCareViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 11/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import LGSideMenuController
import NYAlertViewController
import IQKeyboardManagerSwift
import SDWebImage

class User_CarCareViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //BACK
    @IBOutlet var btnMenuContainerView: UIView?
    @IBOutlet var imageViewMenu: UIImageView?
    @IBOutlet var btnMenu: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var mainCollectionView: UICollectionView?
    
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
    
    var datarows = [ObjProduct]()
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad()
    {
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
        
        lblNavigationTitle?.text = "CAR CARE"
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
                selector: #selector(self.user_got_all_product_by_carEvent),
                name: Notification.Name("user_got_all_product_by_carEvent"),
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
    
    @objc func user_got_all_product_by_carEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayAllProducts
            self.mainCollectionView?.reloadData()
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
        
        //MAIN COLLECTION VIEW
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        //mainCollectionView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainCollectionView?.backgroundColor = MySingleton.sharedManager().themeGlobalLightestGreyColor
        mainCollectionView?.isHidden = false
        
        //registerClass(myFooterViewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "myFooterView")

        
        // API CALL
        dataManager.user_get_my_car_list()
    }
    
    // MARK: UIcollectionView Delegation
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datarows.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = collectionView.frame.size.width / 2
        let cellHeight = collectionView.frame.size.width / 2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reusableIdentifier = NSString(format:"Cell:%d", indexPath.item) as String
        
        mainCollectionView?.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        cell.mainImageView.sd_setImage(with: URL(string: datarows[indexPath.item].strProductImageURL), placeholderImage: nil)
        cell.lblTitle.text = datarows[indexPath.item].strProductName
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (datarows.count > 0)
        {
            let viewController : User_ProductDetailsViewController = User_ProductDetailsViewController()
            viewController.objSelectedCar = self.objSelectedCar
            viewController.objSelectedProduct = datarows[indexPath.item]
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
        dataManager.user_get_all_product_by_car(strCarID: (self.objSelectedCar?.strCarID)!)
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
        print(mainCollectionView?.contentOffset.y as Any)
        
        if scrollView == mainCollectionView
        {
            if Double((mainCollectionView?.contentOffset.y)!) <= 0
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
