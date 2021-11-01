//
//  User_PickLocationViewController.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 12/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
import NYAlertViewController
import IQKeyboardManagerSwift
import GoogleMaps
import CoreLocation

class User_PickLocationViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate
{
    //========== IBOUTLETS ==========//
    
    @IBOutlet var navigationBarView: UIView?
    //BACK
    @IBOutlet var btnBackContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var lblNavigationTitle: UILabel?
    
    @IBOutlet var mainScrollView: UIScrollView?
    
    @IBOutlet var mapContainerView: GMSMapView?
    
    @IBOutlet var lblLocateYourAddress: UILabel?
    @IBOutlet var lblService: UILabel?
    @IBOutlet var btnSelect: UIButton?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
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
        
        btnSelect?.clipsToBounds = true
        btnSelect?.layer.cornerRadius = (btnSelect?.frame.size.height)!/2
        
        mainScrollView?.contentSize = CGSize(width: (mainScrollView?.frame.size.width)!, height: (mainScrollView?.frame.size.height)!)
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar() {
        navigationBarView?.backgroundColor = .clear
        
        imageViewBack?.layer.masksToBounds = true
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        lblNavigationTitle?.text = "PICK A LOCATION"
        lblNavigationTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
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
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
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
        
        lblLocateYourAddress?.font = lblFont
        lblLocateYourAddress?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblLocateYourAddress?.textAlignment = .left
        
        lblService?.font = lblServiceFont
        lblService?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblService?.textAlignment = .left
        
        btnSelect?.titleLabel?.font = txtFont
        btnSelect?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        btnSelect?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnSelect?.addTarget(self, action: #selector(self.btnSelectClicked(_:)), for: .touchUpInside)
        
        // GET CURRENT LAT LONG
        
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return
            }
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 8.0)
            //mapContainerView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapContainerView?.camera = camera
            mapContainerView?.delegate = self
            mapContainerView?.isMyLocationEnabled = true
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            marker.title = ""
            marker.snippet = ""
            marker.isDraggable = true
            marker.map = mapContainerView
            
            // REVERSE GEO CODE
            let geocoder = GMSGeocoder()
            currentAddress = String()
            geocoder.reverseGeocodeCoordinate(currentLocation.coordinate) { response , error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    
                    self.currentAddress = lines.joined(separator: ", ")
                    
                    NSLog("\(self.currentAddress)")
                }
            }
        }
        else
        {
            let camera = GMSCameraPosition.camera(withLatitude: 21.1702, longitude: 72.8311, zoom: 8.0)
            //mapContainerView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapContainerView?.camera = camera
            mapContainerView?.delegate = self
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: 21.1702, longitude: 72.8311)
            marker.title = ""
            marker.snippet = ""
            marker.isDraggable = true
            marker.map = mapContainerView
        }
    }
    
    @IBAction func btnSelectClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        dataManager.currentLocation = self.currentLocation
        dataManager.currentAddress = self.currentAddress
        
        self.navigationController?.popViewController(animated: true)
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
        
        mapContainerView?.clear()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 8.0)
            //mapContainerView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapContainerView?.camera = camera
            mapContainerView?.delegate = self
            mapContainerView?.isMyLocationEnabled = true
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            marker.title = ""
            marker.snippet = ""
            marker.isDraggable = true
            marker.map = mapContainerView
            
            // REVERSE GEO CODE
            let geocoder = GMSGeocoder()
            currentAddress = String()
            geocoder.reverseGeocodeCoordinate(currentLocation.coordinate) { response , error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    
                    self.currentAddress = lines.joined(separator: ", ")
                    
                    NSLog("\(self.currentAddress)")
                }
            }
        }
        else
        {
            let camera = GMSCameraPosition.camera(withLatitude: 21.1702, longitude: 72.8311, zoom: 8.0)
            //mapContainerView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapContainerView?.camera = camera
            mapContainerView?.delegate = self
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: 21.1702, longitude: 72.8311)
            marker.title = ""
            marker.snippet = ""
            marker.isDraggable = true
            marker.map = mapContainerView
        }
    }

    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker)
    {
        currentLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        // REVERSE GEO CODE
        let geocoder = GMSGeocoder()
        currentAddress = String()
        geocoder.reverseGeocodeCoordinate(currentLocation.coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                self.currentAddress = lines.joined(separator: ", ")
                
                NSLog("\(self.currentAddress)")
            }
        }
    }
}
