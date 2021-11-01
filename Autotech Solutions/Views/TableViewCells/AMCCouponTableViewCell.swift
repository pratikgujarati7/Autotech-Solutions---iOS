//
//  AMCCouponTableViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 06/04/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
var AMCCouponTableViewCellHeight: CGFloat = 200

class AMCCouponTableViewCell: UITableViewCell {
    
    var mainContainer: UIView = UIView()
    
    var titleContainer: UIView = UIView()
    var lblAMCTitle: UILabel = UILabel()
    var lblAMCSubTitle: UILabel = UILabel()
    
    var detailsContainer: UIView = UIView()
    
    var lblLaborTitle: UILabel = UILabel()
    var lblLaborValue: UILabel = UILabel()
    
    var verticalSeparatorView: UIView = UIView()
    
    var lblPartsTitle: UILabel = UILabel()
    var lblPartsValue: UILabel = UILabel()
    
    var separatorView: UIView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //======= ADD MAIN CONTAINER VIEW =======//
        mainContainer = UIView(frame: CGRect(x: 5, y: 5, width: MySingleton.sharedManager().screenWidth - 10, height: AMCCouponTableViewCellHeight - 5))
        mainContainer.backgroundColor = MySingleton.sharedManager() .themeGlobalWhiteColor
        
        //======== ADD TITLE CONTAINER INTO MAIN CONTAINER VIEW ========//
        titleContainer = UIView(frame: CGRect(x: 0, y: 0, width: mainContainer.frame.size.width, height: 70))
        titleContainer.backgroundColor = MySingleton.sharedManager() .themeGlobalDarkGreyColor?.withAlphaComponent(0.7)
        
        
        //======== ADD LABLE NOTIFICATION TITLE INTO MAIN CONTAINER VIEW ========//
        lblAMCTitle = UILabel(frame: CGRect(x: 10, y: 10, width: mainContainer.frame.size.width - 20, height: 20))
        lblAMCTitle.textAlignment = .left
        lblAMCTitle.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblAMCTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAMCTitle.numberOfLines = 0
        titleContainer.addSubview(lblAMCTitle)
        
        //======== ADD LABLE NOTIFICATION TEXT INTO MAIN CONTAINER VIEW ========//
        lblAMCSubTitle = UILabel(frame: CGRect(x: 10, y: 40, width: mainContainer.frame.size.width - 20, height: 20))
        lblAMCSubTitle.textAlignment = .left
        lblAMCSubTitle.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAMCSubTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAMCSubTitle.numberOfLines = 0
        titleContainer.addSubview(lblAMCSubTitle)
        
        mainContainer.addSubview(titleContainer)
        
        //======== ADD DETAILS CONTAINER INTO MAIN CONTAINER VIEW ========//
        detailsContainer = UIView(frame: CGRect(x: 0, y: titleContainer.frame.origin.y + titleContainer.frame.size.height, width: mainContainer.frame.size.width, height: 110))
        detailsContainer.backgroundColor = MySingleton.sharedManager() .themeGlobalWhiteColor
        mainContainer.addSubview(detailsContainer)
        
        //======== ADD LABLE NOTIFICATION TITLE INTO MAIN CONTAINER VIEW ========//
        lblLaborTitle = UILabel(frame: CGRect(x: 10, y: 10, width: (mainContainer.frame.size.width - 40)/2, height: 20))
        lblLaborTitle.textAlignment = .left
        lblLaborTitle.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblLaborTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblLaborTitle.numberOfLines = 1
        lblLaborTitle.text = "Labor :"
        detailsContainer.addSubview(lblLaborTitle)
        
        verticalSeparatorView = UIView(frame: CGRect(x: 10 + 9 + (mainContainer.frame.size.width - 40)/2, y: 40, width: 2, height: 20))
        verticalSeparatorView.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor?.withAlphaComponent(0.7)
        detailsContainer.addSubview(verticalSeparatorView)
        
        //======== ADD LABLE NOTIFICATION TEXT INTO MAIN CONTAINER VIEW ========//
        lblLaborValue = UILabel(frame: CGRect(x: 10, y: 40, width: (mainContainer.frame.size.width - 40)/2, height: 20))
        lblLaborValue.textAlignment = .left
        lblLaborValue.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblLaborValue.textColor = MySingleton.sharedManager().themeGlobalRedColor
        lblLaborValue.numberOfLines = 0
        detailsContainer.addSubview(lblLaborValue)
        
        //======== ADD LABLE NOTIFICATION TITLE INTO MAIN CONTAINER VIEW ========//
        lblPartsTitle = UILabel(frame: CGRect(x: 10 + 20 + (mainContainer.frame.size.width - 40)/2, y: 10, width: (mainContainer.frame.size.width - 40)/2, height: 20))
        lblPartsTitle.textAlignment = .left
        lblPartsTitle.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblPartsTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblPartsTitle.numberOfLines = 1
        lblPartsTitle.text = "Parts :"
        detailsContainer.addSubview(lblPartsTitle)
        
        //======== ADD LABLE NOTIFICATION TEXT INTO MAIN CONTAINER VIEW ========//
        lblPartsValue = UILabel(frame: CGRect(x: 10 + 20 + (mainContainer.frame.size.width - 40)/2, y: 40, width: (mainContainer.frame.size.width - 40)/2, height: 20))
        lblPartsValue.textAlignment = .left
        lblPartsValue.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblPartsValue.textColor = MySingleton.sharedManager().themeGlobalRedColor
        lblPartsValue.numberOfLines = 0
        detailsContainer.addSubview(lblPartsValue)
        
        self.addSubview(mainContainer)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
