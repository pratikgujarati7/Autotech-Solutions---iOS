//
//  AMCTableViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 09/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
var AMCTableViewCellHeight: CGFloat = 200

class AMCTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    
    var titleContainer: UIView = UIView()
    var lblAMCTitle: UILabel = UILabel()
    var lblAMCPrice: UILabel = UILabel()
    var lblAMCSubTitle: UILabel = UILabel()
    var btnBuyNow: UIButton = UIButton()
    

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
        mainContainer = UIView(frame: CGRect(x: 5, y: 5, width: MySingleton.sharedManager().screenWidth - 10, height: AMCTableViewCellHeight - 5))
        mainContainer.backgroundColor = MySingleton.sharedManager() .themeGlobalWhiteColor
        
        //======== ADD TITLE CONTAINER INTO MAIN CONTAINER VIEW ========//
        titleContainer = UIView(frame: CGRect(x: 0, y: 0, width: mainContainer.frame.size.width, height: 70))
        titleContainer.backgroundColor = MySingleton.sharedManager() .themeGlobalDarkGreyColor?.withAlphaComponent(0.7)
        
        
        //======== ADD LABLE NOTIFICATION TITLE INTO MAIN CONTAINER VIEW ========//
        lblAMCTitle = UILabel(frame: CGRect(x: 10, y: 10, width: mainContainer.frame.size.width - 20 - 80, height: 20))
        lblAMCTitle.textAlignment = .left
        lblAMCTitle.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblAMCTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAMCTitle.numberOfLines = 0
        titleContainer.addSubview(lblAMCTitle)
        
        lblAMCPrice  = UILabel(frame: CGRect(x: mainContainer.frame.size.width - 80, y: 10, width: 70, height: 20))
        lblAMCPrice.textAlignment = .right
        lblAMCPrice.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblAMCPrice.textColor = MySingleton.sharedManager().themeGlobalRedColor
        lblAMCPrice.numberOfLines = 0
        titleContainer.addSubview(lblAMCPrice)
        
        //======== ADD LABLE NOTIFICATION TEXT INTO MAIN CONTAINER VIEW ========//
        lblAMCSubTitle = UILabel(frame: CGRect(x: 10, y: 40, width: mainContainer.frame.size.width - 20, height: 20))
        lblAMCSubTitle.textAlignment = .left
        lblAMCSubTitle.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAMCSubTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAMCSubTitle.numberOfLines = 0
        titleContainer.addSubview(lblAMCSubTitle)
        
        mainContainer.addSubview(titleContainer)
        
        //======== ADD BUTTON BUY NOW INTO MAIN CONTAINER VIEW ========//
        btnBuyNow = UIButton(frame: CGRect(x: titleContainer.frame.size.width / 3, y: 70, width: titleContainer.frame.size.width / 3, height: 40))
        btnBuyNow.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        btnBuyNow.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
    btnBuyNow.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnBuyNow.clipsToBounds = true
        btnBuyNow.layer.cornerRadius = btnBuyNow.frame.size.height/2
        btnBuyNow.setTitle("Buy Now", for: .normal)
        titleContainer.addSubview(btnBuyNow)
        
        
        self.addSubview(mainContainer)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
