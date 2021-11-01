//
//  AddressTableViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 26/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit
var AddressTableViewCellHeight: CGFloat = 75

class AddressTableViewCell: UITableViewCell
{
    
    var mainContainer: UIView = UIView()
    var lblAddressTitle: UILabel = UILabel()
    var imageViewDelete: UIImageView = UIImageView()
    var btnDelete: UIButton = UIButton()
    var lblAddressText: UILabel = UILabel()
    
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
        mainContainer = UIView(frame: CGRect(x: 0, y: 5, width: MySingleton.sharedManager().screenWidth, height: NotificationTableViewCellHeight - 5))
        mainContainer.backgroundColor = MySingleton.sharedManager() .themeGlobalLightestGreyColor
        
        //======== ADD LABLE ADDRESS TITLE INTO MAIN CONTAINER VIEW ========//
        lblAddressTitle = UILabel(frame: CGRect(x: 10, y: 10, width: mainContainer.frame.size.width - 50, height: 20))
        lblAddressTitle.textAlignment = .left
        lblAddressTitle.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        lblAddressTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAddressTitle.numberOfLines = 0
        mainContainer.addSubview(lblAddressTitle)
        
        //======= ADD DELETE IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        imageViewDelete = UIImageView(frame: CGRect(x: (mainContainer.frame.size.width - 35) , y: 5, width: 25, height: 25))
        imageViewDelete.contentMode = .scaleAspectFit
        imageViewDelete.clipsToBounds = true
        imageViewDelete.image = UIImage(named: "delete.png")
        mainContainer.addSubview(imageViewDelete)
        
        btnDelete = UIButton(frame: CGRect(x: (mainContainer.frame.size.width - 35) , y: 5, width: 25, height: 25))
        btnDelete.tintColor = .clear
        btnDelete.setTitle("", for: .normal)
        mainContainer.addSubview(btnDelete)
        
        //======== ADD LABLE ADDRESS TEXT INTO MAIN CONTAINER VIEW ========//
        lblAddressText = UILabel(frame: CGRect(x: 10, y: 40, width: mainContainer.frame.size.width - 20, height: 20))
        lblAddressText.textAlignment = .left
        lblAddressText.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAddressText.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblAddressText.numberOfLines = 0
        mainContainer.addSubview(lblAddressText)
        
        self.addSubview(mainContainer)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
