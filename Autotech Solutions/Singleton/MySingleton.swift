//
//  MySingleton.swift
//  SwiftDemo
//
//  Created by Infusion on 6/5/15.
//  Copyright (c) 2015 Infusion. All rights reserved.
//

import UIKit
import Foundation

//import LGSideMenuController

import LGSideMenuController.LGSideMenuController
import LGSideMenuController.UIViewController_LGSideMenuController

class MySingleton: NSObject
{
    var screenRect: CGRect
    var screenWidth: CGFloat
    let screenHeight: CGFloat
    
    //========================= APPLICATION SPECIFIC SETTINGS ================//
    
    //========================= SIDE MENU SETTINGS ================//
    
    var selectedScreenIndex: NSInteger
    
    var floatLeftSideMenuWidth: CGFloat?
    var floatRightSideMenuWidth: CGFloat?
    
    var leftViewPresentationStyle: LGSideMenuPresentationStyle?
    var rightViewPresentationStyle: LGSideMenuPresentationStyle?
    
    //========================= NAVIGATION BAR SETTINGS ================/
    var navigationBarBackgroundColor: UIColor?
    var navigationBarTitleColor: UIColor?
    var navigationBarTitleFont: UIFont?
    var navigationBarTitleSmallFont: UIFont?
    
    //========================= THEME GLOBAL COLORS SETTINGS ================//
    var themeGlobalPurpleColor: UIColor?
    var themeGlobalBlueColor: UIColor?
    var themeGlobalGreenColor: UIColor?
    var themeGlobalLightGreenColor: UIColor?
    var themeGlobalRedColor: UIColor?
    var themeGlobalWhiteColor: UIColor?
    var themeGlobalBlackColor: UIColor?
    var themeGlobalDarkGreyColor: UIColor?
    var themeGlobalLightGreyColor: UIColor?
    var themeGlobalLightestGreyColor: UIColor?
    var themeGlobalSeperatorGreyColor: UIColor?
    var themeGlobalSideMenuSeperatorColor: UIColor?
    
    var textfieldPlaceholderColor: UIColor?
    var textfieldTextColor: UIColor?
    var textfieldRedTextColor: UIColor?
    var textfieldDisabledTextColor: UIColor?
    var textfieldFloatingLabelTextColor: UIColor?
    var textfieldBottomSeparatorColor: UIColor?
    
    var textfieldPlaceholderLoginColor: UIColor?
    var textfieldTextLoginColor: UIColor?
    
    //========================= THEME GLOBAL CUSTOM COLORS SETTINGS ================//
    var themeGlobalOrangeColor: UIColor?
    var themeGlobalFacebookColor: UIColor?
    var themeGlobalGoogleColor: UIColor?
    
    //========================= FLOAT VALUES SETTINGS ================//
    var floatButtonCornerRadius: CGFloat?
    
    //========================= THEME REGULAR FONTS SETTING ================//
    var themeFontFourSizeRegular: UIFont?
    var themeFontFiveSizeRegular: UIFont?
    var themeFontSixSizeRegular: UIFont?
    var themeFontSevenSizeRegular: UIFont?
    var themeFontEightSizeRegular: UIFont?
    var themeFontNineSizeRegular: UIFont?
    var themeFontTenSizeRegular: UIFont?
    var themeFontElevenSizeRegular: UIFont?
    var themeFontTwelveSizeRegular: UIFont?
    var themeFontThirteenSizeRegular: UIFont?
    var themeFontFourteenSizeRegular: UIFont?
    var themeFontFifteenSizeRegular: UIFont?
    var themeFontSixteenSizeRegular: UIFont?
    var themeFontSeventeenSizeRegular: UIFont?
    var themeFontEighteenSizeRegular: UIFont?
    var themeFontNineteenSizeRegular: UIFont?
    var themeFontTwentySizeRegular: UIFont?
    var themeFontTwentyOneSizeRegular: UIFont?
    var themeFontTwentyTwoSizeRegular: UIFont?
    var themeFontTwentyThreeSizeRegular: UIFont?
    var themeFontTwentyFourSizeRegular: UIFont?
    var themeFontTwentyFiveSizeRegular: UIFont?
    var themeFontTwentySixSizeRegular: UIFont?
    var themeFontTwentySevenSizeRegular: UIFont?
    var themeFontTwentyEightSizeRegular: UIFont?
    var themeFontTwentyNineSizeRegular: UIFont?
    var themeFontThirtySizeRegular: UIFont?
    var themeFontThirtyOneSizeRegular: UIFont?
    var themeFontThirtyTwoSizeRegular: UIFont?
    var themeFontThirtyThreeSizeRegular: UIFont?
    var themeFontThirtyFourSizeRegular: UIFont?
    var themeFontThirtyFiveSizeRegular: UIFont?
    var themeFontThirtySixSizeRegular: UIFont?
    var themeFontThirtySevenSizeRegular: UIFont?
    var themeFontThirtyEightSizeRegular: UIFont?
    var themeFontThirtyNineSizeRegular: UIFont?
    var themeFontFourtySizeRegular: UIFont?
    var themeFontFourtyOneSizeRegular: UIFont?
    var themeFontFourtyTwoSizeRegular: UIFont?
    var themeFontFourtyThreeSizeRegular: UIFont?
    var themeFontFourtyFourSizeRegular: UIFont?
    var themeFontFourtyFiveSizeRegular: UIFont?
    var themeFontFourtySixSizeRegular: UIFont?
    var themeFontFourtySevenSizeRegular: UIFont?
    var themeFontFourtyEightSizeRegular: UIFont?
    
    //========================= THEME LIGHT FONTS SETTING ================//
    var themeFontFourSizeLight: UIFont?
    var themeFontFiveSizeLight: UIFont?
    var themeFontSixSizeLight: UIFont?
    var themeFontSevenSizeLight: UIFont?
    var themeFontEightSizeLight: UIFont?
    var themeFontNineSizeLight: UIFont?
    var themeFontTenSizeLight: UIFont?
    var themeFontElevenSizeLight: UIFont?
    var themeFontTwelveSizeLight: UIFont?
    var themeFontThirteenSizeLight: UIFont?
    var themeFontFourteenSizeLight: UIFont?
    var themeFontFifteenSizeLight: UIFont?
    var themeFontSixteenSizeLight: UIFont?
    var themeFontSeventeenSizeLight: UIFont?
    var themeFontEighteenSizeLight: UIFont?
    var themeFontNineteenSizeLight: UIFont?
    var themeFontTwentySizeLight: UIFont?
    var themeFontTwentyOneSizeLight: UIFont?
    var themeFontTwentyTwoSizeLight: UIFont?
    var themeFontTwentyThreeSizeLight: UIFont?
    var themeFontTwentyFourSizeLight: UIFont?
    var themeFontTwentyFiveSizeLight: UIFont?
    var themeFontTwentySixSizeLight: UIFont?
    var themeFontTwentySevenSizeLight: UIFont?
    var themeFontTwentyEightSizeLight: UIFont?
    var themeFontTwentyNineSizeLight: UIFont?
    var themeFontThirtySizeLight: UIFont?
    var themeFontThirtyOneSizeLight: UIFont?
    var themeFontThirtyTwoSizeLight: UIFont?
    var themeFontThirtyThreeSizeLight: UIFont?
    var themeFontThirtyFourSizeLight: UIFont?
    var themeFontThirtyFiveSizeLight: UIFont?
    var themeFontThirtySixSizeLight: UIFont?
    var themeFontThirtySevenSizeLight: UIFont?
    var themeFontThirtyEightSizeLight: UIFont?
    var themeFontThirtyNineSizeLight: UIFont?
    var themeFontFourtySizeLight: UIFont?
    var themeFontFourtyOneSizeLight: UIFont?
    var themeFontFourtyTwoSizeLight: UIFont?
    var themeFontFourtyThreeSizeLight: UIFont?
    var themeFontFourtyFourSizeLight: UIFont?
    var themeFontFourtyFiveSizeLight: UIFont?
    var themeFontFourtySixSizeLight: UIFont?
    var themeFontFourtySevenSizeLight: UIFont?
    var themeFontFourtyEightSizeLight: UIFont?
    
    //========================= THEME MEDIUM FONTS SETTING ================//
    var themeFontFourSizeMedium: UIFont?
    var themeFontFiveSizeMedium: UIFont?
    var themeFontSixSizeMedium: UIFont?
    var themeFontSevenSizeMedium: UIFont?
    var themeFontEightSizeMedium: UIFont?
    var themeFontNineSizeMedium: UIFont?
    var themeFontTenSizeMedium: UIFont?
    var themeFontElevenSizeMedium: UIFont?
    var themeFontTwelveSizeMedium: UIFont?
    var themeFontThirteenSizeMedium: UIFont?
    var themeFontFourteenSizeMedium: UIFont?
    var themeFontFifteenSizeMedium: UIFont?
    var themeFontSixteenSizeMedium: UIFont?
    var themeFontSeventeenSizeMedium: UIFont?
    var themeFontEighteenSizeMedium: UIFont?
    var themeFontNineteenSizeMedium: UIFont?
    var themeFontTwentySizeMedium: UIFont?
    var themeFontTwentyOneSizeMedium: UIFont?
    var themeFontTwentyTwoSizeMedium: UIFont?
    var themeFontTwentyThreeSizeMedium: UIFont?
    var themeFontTwentyFourSizeMedium: UIFont?
    var themeFontTwentyFiveSizeMedium: UIFont?
    var themeFontTwentySixSizeMedium: UIFont?
    var themeFontTwentySevenSizeMedium: UIFont?
    var themeFontTwentyEightSizeMedium: UIFont?
    var themeFontTwentyNineSizeMedium: UIFont?
    var themeFontThirtySizeMedium: UIFont?
    var themeFontThirtyOneSizeMedium: UIFont?
    var themeFontThirtyTwoSizeMedium: UIFont?
    var themeFontThirtyThreeSizeMedium: UIFont?
    var themeFontThirtyFourSizeMedium: UIFont?
    var themeFontThirtyFiveSizeMedium: UIFont?
    var themeFontThirtySixSizeMedium: UIFont?
    var themeFontThirtySevenSizeMedium: UIFont?
    var themeFontThirtyEightSizeMedium: UIFont?
    var themeFontThirtyNineSizeMedium: UIFont?
    var themeFontFourtySizeMedium: UIFont?
    var themeFontFourtyOneSizeMedium: UIFont?
    var themeFontFourtyTwoSizeMedium: UIFont?
    var themeFontFourtyThreeSizeMedium: UIFont?
    var themeFontFourtyFourSizeMedium: UIFont?
    var themeFontFourtyFiveSizeMedium: UIFont?
    var themeFontFourtySixSizeMedium: UIFont?
    var themeFontFourtySevenSizeMedium: UIFont?
    var themeFontFourtyEightSizeMedium: UIFont?
    
    //========================= THEME BOLD FONTS SETTING ================//
    var themeFontFourSizeBold: UIFont?
    var themeFontFiveSizeBold: UIFont?
    var themeFontSixSizeBold: UIFont?
    var themeFontSevenSizeBold: UIFont?
    var themeFontEightSizeBold: UIFont?
    var themeFontNineSizeBold: UIFont?
    var themeFontTenSizeBold: UIFont?
    var themeFontElevenSizeBold: UIFont?
    var themeFontTwelveSizeBold: UIFont?
    var themeFontThirteenSizeBold: UIFont?
    var themeFontFourteenSizeBold: UIFont?
    var themeFontFifteenSizeBold: UIFont?
    var themeFontSixteenSizeBold: UIFont?
    var themeFontSeventeenSizeBold: UIFont?
    var themeFontEighteenSizeBold: UIFont?
    var themeFontNineteenSizeBold: UIFont?
    var themeFontTwentySizeBold: UIFont?
    var themeFontTwentyOneSizeBold: UIFont?
    var themeFontTwentyTwoSizeBold: UIFont?
    var themeFontTwentyThreeSizeBold: UIFont?
    var themeFontTwentyFourSizeBold: UIFont?
    var themeFontTwentyFiveSizeBold: UIFont?
    var themeFontTwentySixSizeBold: UIFont?
    var themeFontTwentySevenSizeBold: UIFont?
    var themeFontTwentyEightSizeBold: UIFont?
    var themeFontTwentyNineSizeBold: UIFont?
    var themeFontThirtySizeBold: UIFont?
    var themeFontThirtyOneSizeBold: UIFont?
    var themeFontThirtyTwoSizeBold: UIFont?
    var themeFontThirtyThreeSizeBold: UIFont?
    var themeFontThirtyFourSizeBold: UIFont?
    var themeFontThirtyFiveSizeBold: UIFont?
    var themeFontThirtySixSizeBold: UIFont?
    var themeFontThirtySevenSizeBold: UIFont?
    var themeFontThirtyEightSizeBold: UIFont?
    var themeFontThirtyNineSizeBold: UIFont?
    var themeFontFourtySizeBold: UIFont?
    var themeFontFourtyOneSizeBold: UIFont?
    var themeFontFourtyTwoSizeBold: UIFont?
    var themeFontFourtyThreeSizeBold: UIFont?
    var themeFontFourtyFourSizeBold: UIFont?
    var themeFontFourtyFiveSizeBold: UIFont?
    var themeFontFourtySixSizeBold: UIFont?
    var themeFontFourtySevenSizeBold: UIFont?
    var themeFontFourtyEightSizeBold: UIFont?
    
    //========================= ALERT VIEW SETTINGS ================//
    var alertViewTitleFont: UIFont?
    var alertViewMessageFont: UIFont?
    var alertViewButtonTitleFont: UIFont?
    var alertViewCancelButtonTitleFont: UIFont?
    
    var alertViewTitleColor: UIColor?
    var alertViewContentColor: UIColor?
    var alertViewLeftButtonFontColor: UIColor?
    var alertViewBackGroundColor: UIColor?
    var alertViewLeftButtonBackgroundColor: UIColor?
    var alertViewRightButtonBackgroundColor: UIColor?
    
    //========================= OTHER CUSTOM METHODS ================//
    
    class func sharedManager() -> MySingleton
    {
        return _sharedManager
    }
    
    override init()
    {
        screenRect = UIScreen.main.bounds
        screenWidth = screenRect.width
        screenHeight = screenRect.height
        
        //========================= APPLICATION SPECIFIC SETTINGS ================//
        
        //========================= SIDE MENU SETTINGS ================//
        
        selectedScreenIndex = 0;
        
        floatLeftSideMenuWidth = (screenWidth/10) * 7
        floatRightSideMenuWidth = (screenWidth/10) * 7
        
        leftViewPresentationStyle = LGSideMenuPresentationStyle.slideBelow
        rightViewPresentationStyle = LGSideMenuPresentationStyle.scaleFromBig
        
        //========================= NAVIGATION BAR SETTINGS ================/
        navigationBarBackgroundColor = UIColor(rgb: 0xFFFFFF)
        navigationBarTitleColor = UIColor(rgb: 0x4a4a4a)
        
        if screenWidth == 320
        {
            navigationBarTitleFont = UIFont(name: "Montserrat-Bold", size: 16.0)
            navigationBarTitleSmallFont = UIFont(name: "Montserrat-Bold", size: 14.0)
        }
        else if screenWidth == 375
        {
            navigationBarTitleFont = UIFont(name: "Montserrat-Bold", size: 17.0)
            navigationBarTitleSmallFont = UIFont(name: "Montserrat-Bold", size: 14.0)
        }
        else
        {
            navigationBarTitleFont = UIFont(name: "Montserrat-Bold", size: 18.0)
            navigationBarTitleSmallFont = UIFont(name: "Montserrat-Bold", size: 14.0)
        }
        
        //========================= THEME GLOBAL COLORS SETTINGS ================//
        themeGlobalPurpleColor = UIColor(rgb: 0xff6666)
        themeGlobalBlueColor = UIColor(rgb: 0x28689e)
        themeGlobalGreenColor = UIColor(rgb: 0x64AA4A)
        themeGlobalLightGreenColor = UIColor(rgb: 0xF2530D).withAlphaComponent(0.0)//UIColor(rgb: 0xA1D57A)
        themeGlobalRedColor = UIColor(rgb: 0xA01A1F)
        themeGlobalWhiteColor = UIColor(rgb: 0xFFFFFF)
        themeGlobalBlackColor = UIColor(rgb: 0x4a4a4a)
        themeGlobalDarkGreyColor = UIColor(rgb: 0x868686)
        themeGlobalLightGreyColor = UIColor(rgb: 0xefefef)
        themeGlobalLightestGreyColor = UIColor(rgb: 0xF2F2F2)
        themeGlobalSeperatorGreyColor = UIColor(rgb: 0xDCDCDC)
        themeGlobalSideMenuSeperatorColor = UIColor(rgb: 0x868686)
        
        textfieldPlaceholderColor = UIColor(rgb: 0x868686)
        textfieldTextColor = UIColor(rgb: 0x4a4a4a)
        textfieldRedTextColor = UIColor(rgb: 0xA01A1F)
        textfieldDisabledTextColor = UIColor(rgb: 0x868686)
        textfieldFloatingLabelTextColor = UIColor(rgb: 0x2A4A7D)
        textfieldBottomSeparatorColor = UIColor(rgb: 0x9FA0A1)
        
        textfieldPlaceholderLoginColor = UIColor(rgb: 0xFFFFFF).withAlphaComponent(0.5)
        textfieldTextLoginColor = UIColor(rgb: 0xFFFFFF)
        
        //========================= THEME GLOBAL CUSTOM COLORS SETTINGS ================//
        themeGlobalOrangeColor = UIColor(rgb: 0xF2530D)
        themeGlobalFacebookColor = UIColor(rgb: 0x3b5998)
        themeGlobalGoogleColor = UIColor(rgb: 0xdb3236)
        
        //========================= FLOAT VALUES SETTINGS ================//
        floatButtonCornerRadius = 10.0
        
        //========================= THEME REGULAR FONTS SETTING ================//
        themeFontFourSizeRegular = UIFont(name: "Montserrat-Regular", size: 4.0)
        themeFontFiveSizeRegular = UIFont(name: "Montserrat-Regular", size: 5.0)
        themeFontSixSizeRegular = UIFont(name: "Montserrat-Regular", size: 6.0)
        themeFontSevenSizeRegular = UIFont(name: "Montserrat-Regular", size: 7.0)
        themeFontEightSizeRegular = UIFont(name: "Montserrat-Regular", size: 8.0)
        themeFontNineSizeRegular = UIFont(name: "Montserrat-Regular", size: 9.0)
        themeFontTenSizeRegular = UIFont(name: "Montserrat-Regular", size: 10.0)
        themeFontElevenSizeRegular = UIFont(name: "Montserrat-Regular", size: 11.0)
        themeFontTwelveSizeRegular = UIFont(name: "Montserrat-Regular", size: 12.0)
        themeFontThirteenSizeRegular = UIFont(name: "Montserrat-Regular", size: 13.0)
        themeFontFourteenSizeRegular = UIFont(name: "Montserrat-Regular", size: 14.0)
        themeFontFifteenSizeRegular = UIFont(name: "Montserrat-Regular", size: 15.0)
        themeFontSixteenSizeRegular = UIFont(name: "Montserrat-Regular", size: 16.0)
        themeFontSeventeenSizeRegular = UIFont(name: "Montserrat-Regular", size: 17.0)
        themeFontEighteenSizeRegular = UIFont(name: "Montserrat-Regular", size: 18.0)
        themeFontNineteenSizeRegular = UIFont(name: "Montserrat-Regular", size: 19.0)
        themeFontTwentySizeRegular = UIFont(name: "Montserrat-Regular", size: 20.0)
        themeFontTwentyOneSizeRegular = UIFont(name: "Montserrat-Regular", size: 21.0)
        themeFontTwentyTwoSizeRegular = UIFont(name: "Montserrat-Regular", size: 22.0)
        themeFontTwentyThreeSizeRegular = UIFont(name: "Montserrat-Regular", size: 23.0)
        themeFontTwentyFourSizeRegular = UIFont(name: "Montserrat-Regular", size: 24.0)
        themeFontTwentyFiveSizeRegular = UIFont(name: "Montserrat-Regular", size: 25.0)
        themeFontTwentySixSizeRegular = UIFont(name: "Montserrat-Regular", size: 26.0)
        themeFontTwentySevenSizeRegular = UIFont(name: "Montserrat-Regular", size: 27.0)
        themeFontTwentyEightSizeRegular = UIFont(name: "Montserrat-Regular", size: 28.0)
        themeFontTwentyNineSizeRegular = UIFont(name: "Montserrat-Regular", size: 29.0)
        themeFontThirtySizeRegular = UIFont(name: "Montserrat-Regular", size: 30.0)
        themeFontThirtyOneSizeRegular = UIFont(name: "Montserrat-Regular", size: 31.0)
        themeFontThirtyTwoSizeRegular = UIFont(name: "Montserrat-Regular", size: 32.0)
        themeFontThirtyThreeSizeRegular = UIFont(name: "Montserrat-Regular", size: 33.0)
        themeFontThirtyFourSizeRegular = UIFont(name: "Montserrat-Regular", size: 34.0)
        themeFontThirtyFiveSizeRegular = UIFont(name: "Montserrat-Regular", size: 35.0)
        themeFontThirtySixSizeRegular = UIFont(name: "Montserrat-Regular", size: 36.0)
        themeFontThirtySevenSizeRegular = UIFont(name: "Montserrat-Regular", size: 37.0)
        themeFontThirtyEightSizeRegular = UIFont(name: "Montserrat-Regular", size: 38.0)
        themeFontThirtyNineSizeRegular = UIFont(name: "Montserrat-Regular", size: 39.0)
        themeFontFourtySizeRegular = UIFont(name: "Montserrat-Regular", size: 40.0)
        themeFontFourtyOneSizeRegular = UIFont(name: "Montserrat-Regular", size: 41.0)
        themeFontFourtyTwoSizeRegular = UIFont(name: "Montserrat-Regular", size: 42.0)
        themeFontFourtyThreeSizeRegular = UIFont(name: "Montserrat-Regular", size: 43.0)
        themeFontFourtyFourSizeRegular = UIFont(name: "Montserrat-Regular", size: 44.0)
        themeFontFourtyFiveSizeRegular = UIFont(name: "Montserrat-Regular", size: 45.0)
        themeFontFourtySixSizeRegular = UIFont(name: "Montserrat-Regular", size: 46.0)
        themeFontFourtySevenSizeRegular = UIFont(name: "Montserrat-Regular", size: 47.0)
        themeFontFourtyEightSizeRegular = UIFont(name: "Montserrat-Regular", size: 48.0)
        
        //========================= THEME LIGHT FONTS SETTING ================//
        themeFontFourSizeLight = UIFont(name: "Montserrat-Light", size: 4.0)
        themeFontFiveSizeLight = UIFont(name: "Montserrat-Light", size: 5.0)
        themeFontSixSizeLight = UIFont(name: "Montserrat-Light", size: 6.0)
        themeFontSevenSizeLight = UIFont(name: "Montserrat-Light", size: 7.0)
        themeFontEightSizeLight = UIFont(name: "Montserrat-Light", size: 8.0)
        themeFontNineSizeLight = UIFont(name: "Montserrat-Light", size: 9.0)
        themeFontTenSizeLight = UIFont(name: "Montserrat-Light", size: 10.0)
        themeFontElevenSizeLight = UIFont(name: "Montserrat-Light", size: 11.0)
        themeFontTwelveSizeLight = UIFont(name: "Montserrat-Light", size: 12.0)
        themeFontThirteenSizeLight = UIFont(name: "Montserrat-Light", size: 13.0)
        themeFontFourteenSizeLight = UIFont(name: "Montserrat-Light", size: 14.0)
        themeFontFifteenSizeLight = UIFont(name: "Montserrat-Light", size: 15.0)
        themeFontSixteenSizeLight = UIFont(name: "Montserrat-Light", size: 16.0)
        themeFontSeventeenSizeLight = UIFont(name: "Montserrat-Light", size: 17.0)
        themeFontEighteenSizeLight = UIFont(name: "Montserrat-Light", size: 18.0)
        themeFontNineteenSizeLight = UIFont(name: "Montserrat-Light", size: 19.0)
        themeFontTwentySizeLight = UIFont(name: "Montserrat-Light", size: 20.0)
        themeFontTwentyOneSizeLight = UIFont(name: "Montserrat-Light", size: 21.0)
        themeFontTwentyTwoSizeLight = UIFont(name: "Montserrat-Light", size: 22.0)
        themeFontTwentyThreeSizeLight = UIFont(name: "Montserrat-Light", size: 23.0)
        themeFontTwentyFourSizeLight = UIFont(name: "Montserrat-Light", size: 24.0)
        themeFontTwentyFiveSizeLight = UIFont(name: "Montserrat-Light", size: 25.0)
        themeFontTwentySixSizeLight = UIFont(name: "Montserrat-Light", size: 26.0)
        themeFontTwentySevenSizeLight = UIFont(name: "Montserrat-Light", size: 27.0)
        themeFontTwentyEightSizeLight = UIFont(name: "Montserrat-Light", size: 28.0)
        themeFontTwentyNineSizeLight = UIFont(name: "Montserrat-Light", size: 29.0)
        themeFontThirtySizeLight = UIFont(name: "Montserrat-Light", size: 30.0)
        themeFontThirtyOneSizeLight = UIFont(name: "Montserrat-Light", size: 31.0)
        themeFontThirtyTwoSizeLight = UIFont(name: "Montserrat-Light", size: 32.0)
        themeFontThirtyThreeSizeLight = UIFont(name: "Montserrat-Light", size: 33.0)
        themeFontThirtyFourSizeLight = UIFont(name: "Montserrat-Light", size: 34.0)
        themeFontThirtyFiveSizeLight = UIFont(name: "Montserrat-Light", size: 35.0)
        themeFontThirtySixSizeLight = UIFont(name: "Montserrat-Light", size: 36.0)
        themeFontThirtySevenSizeLight = UIFont(name: "Montserrat-Light", size: 37.0)
        themeFontThirtyEightSizeLight = UIFont(name: "Montserrat-Light", size: 38.0)
        themeFontThirtyNineSizeLight = UIFont(name: "Montserrat-Light", size: 39.0)
        themeFontFourtySizeLight = UIFont(name: "Montserrat-Light", size: 40.0)
        themeFontFourtyOneSizeLight = UIFont(name: "Montserrat-Light", size: 41.0)
        themeFontFourtyTwoSizeLight = UIFont(name: "Montserrat-Light", size: 42.0)
        themeFontFourtyThreeSizeLight = UIFont(name: "Montserrat-Light", size: 43.0)
        themeFontFourtyFourSizeLight = UIFont(name: "Montserrat-Light", size: 44.0)
        themeFontFourtyFiveSizeLight = UIFont(name: "Montserrat-Light", size: 45.0)
        themeFontFourtySixSizeLight = UIFont(name: "Montserrat-Light", size: 46.0)
        themeFontFourtySevenSizeLight = UIFont(name: "Montserrat-Light", size: 47.0)
        themeFontFourtyEightSizeLight = UIFont(name: "Montserrat-Light", size: 48.0)
        
        //========================= THEME MEDIUM FONTS SETTING ================//
        themeFontFourSizeMedium = UIFont(name: "Montserrat-Medium", size: 4.0)
        themeFontFiveSizeMedium = UIFont(name: "Montserrat-Medium", size: 5.0)
        themeFontSixSizeMedium = UIFont(name: "Montserrat-Medium", size: 6.0)
        themeFontSevenSizeMedium = UIFont(name: "Montserrat-Medium", size: 7.0)
        themeFontEightSizeMedium = UIFont(name: "Montserrat-Medium", size: 8.0)
        themeFontNineSizeMedium = UIFont(name: "Montserrat-Medium", size: 9.0)
        themeFontTenSizeMedium = UIFont(name: "Montserrat-Medium", size: 10.0)
        themeFontElevenSizeMedium = UIFont(name: "Montserrat-Medium", size: 11.0)
        themeFontTwelveSizeMedium = UIFont(name: "Montserrat-Medium", size: 12.0)
        themeFontThirteenSizeMedium = UIFont(name: "Montserrat-Medium", size: 13.0)
        themeFontFourteenSizeMedium = UIFont(name: "Montserrat-Medium", size: 14.0)
        themeFontFifteenSizeMedium = UIFont(name: "Montserrat-Medium", size: 15.0)
        themeFontSixteenSizeMedium = UIFont(name: "Montserrat-Medium", size: 16.0)
        themeFontSeventeenSizeMedium = UIFont(name: "Montserrat-Medium", size: 17.0)
        themeFontEighteenSizeMedium = UIFont(name: "Montserrat-Medium", size: 18.0)
        themeFontNineteenSizeMedium = UIFont(name: "Montserrat-Medium", size: 19.0)
        themeFontTwentySizeMedium = UIFont(name: "Montserrat-Medium", size: 20.0)
        themeFontTwentyOneSizeMedium = UIFont(name: "Montserrat-Medium", size: 21.0)
        themeFontTwentyTwoSizeMedium = UIFont(name: "Montserrat-Medium", size: 22.0)
        themeFontTwentyThreeSizeMedium = UIFont(name: "Montserrat-Medium", size: 23.0)
        themeFontTwentyFourSizeMedium = UIFont(name: "Montserrat-Medium", size: 24.0)
        themeFontTwentyFiveSizeMedium = UIFont(name: "Montserrat-Medium", size: 25.0)
        themeFontTwentySixSizeMedium = UIFont(name: "Montserrat-Medium", size: 26.0)
        themeFontTwentySevenSizeMedium = UIFont(name: "Montserrat-Medium", size: 27.0)
        themeFontTwentyEightSizeMedium = UIFont(name: "Montserrat-Medium", size: 28.0)
        themeFontTwentyNineSizeMedium = UIFont(name: "Montserrat-Medium", size: 29.0)
        themeFontThirtySizeMedium = UIFont(name: "Montserrat-Medium", size: 30.0)
        themeFontThirtyOneSizeMedium = UIFont(name: "Montserrat-Medium", size: 31.0)
        themeFontThirtyTwoSizeMedium = UIFont(name: "Montserrat-Medium", size: 32.0)
        themeFontThirtyThreeSizeMedium = UIFont(name: "Montserrat-Medium", size: 33.0)
        themeFontThirtyFourSizeMedium = UIFont(name: "Montserrat-Medium", size: 34.0)
        themeFontThirtyFiveSizeMedium = UIFont(name: "Montserrat-Medium", size: 35.0)
        themeFontThirtySixSizeMedium = UIFont(name: "Montserrat-Medium", size: 36.0)
        themeFontThirtySevenSizeMedium = UIFont(name: "Montserrat-Medium", size: 37.0)
        themeFontThirtyEightSizeMedium = UIFont(name: "Montserrat-Medium", size: 38.0)
        themeFontThirtyNineSizeMedium = UIFont(name: "Montserrat-Medium", size: 39.0)
        themeFontFourtySizeMedium = UIFont(name: "Montserrat-Medium", size: 40.0)
        themeFontFourtyOneSizeMedium = UIFont(name: "Montserrat-Medium", size: 41.0)
        themeFontFourtyTwoSizeMedium = UIFont(name: "Montserrat-Medium", size: 42.0)
        themeFontFourtyThreeSizeMedium = UIFont(name: "Montserrat-Medium", size: 43.0)
        themeFontFourtyFourSizeMedium = UIFont(name: "Montserrat-Medium", size: 44.0)
        themeFontFourtyFiveSizeMedium = UIFont(name: "Montserrat-Medium", size: 45.0)
        themeFontFourtySixSizeMedium = UIFont(name: "Montserrat-Medium", size: 46.0)
        themeFontFourtySevenSizeMedium = UIFont(name: "Montserrat-Medium", size: 47.0)
        themeFontFourtyEightSizeMedium = UIFont(name: "Montserrat-Medium", size: 48.0)
        
        //========================= THEME BOLD FONTS SETTING ================//
        themeFontFourSizeBold = UIFont(name: "Montserrat-Bold", size: 4.0)
        themeFontFiveSizeBold = UIFont(name: "Montserrat-Bold", size: 5.0)
        themeFontSixSizeBold = UIFont(name: "Montserrat-Bold", size: 6.0)
        themeFontSevenSizeBold = UIFont(name: "Montserrat-Bold", size: 7.0)
        themeFontEightSizeBold = UIFont(name: "Montserrat-Bold", size: 8.0)
        themeFontNineSizeBold = UIFont(name: "Montserrat-Bold", size: 9.0)
        themeFontTenSizeBold = UIFont(name: "Montserrat-Bold", size: 10.0)
        themeFontElevenSizeBold = UIFont(name: "Montserrat-Bold", size: 11.0)
        themeFontTwelveSizeBold = UIFont(name: "Montserrat-Bold", size: 12.0)
        themeFontThirteenSizeBold = UIFont(name: "Montserrat-Bold", size: 13.0)
        themeFontFourteenSizeBold = UIFont(name: "Montserrat-Bold", size: 14.0)
        themeFontFifteenSizeBold = UIFont(name: "Montserrat-Bold", size: 15.0)
        themeFontSixteenSizeBold = UIFont(name: "Montserrat-Bold", size: 16.0)
        themeFontSeventeenSizeBold = UIFont(name: "Montserrat-Bold", size: 17.0)
        themeFontEighteenSizeBold = UIFont(name: "Montserrat-Bold", size: 18.0)
        themeFontNineteenSizeBold = UIFont(name: "Montserrat-Bold", size: 19.0)
        themeFontTwentySizeBold = UIFont(name: "Montserrat-Bold", size: 20.0)
        themeFontTwentyOneSizeBold = UIFont(name: "Montserrat-Bold", size: 21.0)
        themeFontTwentyTwoSizeBold = UIFont(name: "Montserrat-Bold", size: 22.0)
        themeFontTwentyThreeSizeBold = UIFont(name: "Montserrat-Bold", size: 23.0)
        themeFontTwentyFourSizeBold = UIFont(name: "Montserrat-Bold", size: 24.0)
        themeFontTwentyFiveSizeBold = UIFont(name: "Montserrat-Bold", size: 25.0)
        themeFontTwentySixSizeBold = UIFont(name: "Montserrat-Bold", size: 26.0)
        themeFontTwentySevenSizeBold = UIFont(name: "Montserrat-Bold", size: 27.0)
        themeFontTwentyEightSizeBold = UIFont(name: "Montserrat-Bold", size: 28.0)
        themeFontTwentyNineSizeBold = UIFont(name: "Montserrat-Bold", size: 29.0)
        themeFontThirtySizeBold = UIFont(name: "Montserrat-Bold", size: 30.0)
        themeFontThirtyOneSizeBold = UIFont(name: "Montserrat-Bold", size: 31.0)
        themeFontThirtyTwoSizeBold = UIFont(name: "Montserrat-Bold", size: 32.0)
        themeFontThirtyThreeSizeBold = UIFont(name: "Montserrat-Bold", size: 33.0)
        themeFontThirtyFourSizeBold = UIFont(name: "Montserrat-Bold", size: 34.0)
        themeFontThirtyFiveSizeBold = UIFont(name: "Montserrat-Bold", size: 35.0)
        themeFontThirtySixSizeBold = UIFont(name: "Montserrat-Bold", size: 36.0)
        themeFontThirtySevenSizeBold = UIFont(name: "Montserrat-Bold", size: 37.0)
        themeFontThirtyEightSizeBold = UIFont(name: "Montserrat-Bold", size: 38.0)
        themeFontThirtyNineSizeBold = UIFont(name: "Montserrat-Bold", size: 39.0)
        themeFontFourtySizeBold = UIFont(name: "Montserrat-Bold", size: 40.0)
        themeFontFourtyOneSizeBold = UIFont(name: "Montserrat-Bold", size: 41.0)
        themeFontFourtyTwoSizeBold = UIFont(name: "Montserrat-Bold", size: 42.0)
        themeFontFourtyThreeSizeBold = UIFont(name: "Montserrat-Bold", size: 43.0)
        themeFontFourtyFourSizeBold = UIFont(name: "Montserrat-Bold", size: 44.0)
        themeFontFourtyFiveSizeBold = UIFont(name: "Montserrat-Bold", size: 45.0)
        themeFontFourtySixSizeBold = UIFont(name: "Montserrat-Bold", size: 46.0)
        themeFontFourtySevenSizeBold = UIFont(name: "Montserrat-Bold", size: 47.0)
        themeFontFourtyEightSizeBold = UIFont(name: "Montserrat-Bold", size: 48.0)
        
        //========================= ALERT VIEW SETTINGS ================//
        alertViewTitleFont = UIFont(name: "Montserrat-Bold", size: 18.0)
        alertViewMessageFont = UIFont(name: "Montserrat-Regular", size: 14.0)
        alertViewButtonTitleFont = UIFont(name: "Montserrat-Regular", size: 16.0)
        alertViewCancelButtonTitleFont = UIFont(name: "Montserrat-Medium", size: 16.0)
        
        alertViewTitleColor = UIColor(rgb: 0x0092DD)
        alertViewContentColor = UIColor(rgb: 0x4a4a4a)
        alertViewLeftButtonFontColor = UIColor(rgb: 0xFFFFFF)
        alertViewBackGroundColor = UIColor(rgb: 0xFFFFFF)
        alertViewLeftButtonBackgroundColor = UIColor(rgb: 0xc02135)
        alertViewRightButtonBackgroundColor = UIColor(rgb: 0x0092DD)
        
        //========================= OTHER CUSTOM METHODS ================//
        
        super.init()
    }
}

let _sharedManager: MySingleton = { MySingleton() }()

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
