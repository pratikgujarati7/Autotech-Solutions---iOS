//
//  SideMenuTableViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 29/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
var SideMenuTableViewCellHeight: CGFloat = 50

class SideMenuTableViewCell: UITableViewCell {
    
    var mainContainer: UIView = UIView()
    var imageViewItem: UIImageView = UIImageView()
    var lblItemName: UILabel = UILabel()
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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: SideMenuTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.white
        
        //======= ADD NOTIFICATION IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        imageViewItem = UIImageView(frame: CGRect(x: 10, y: 15, width: 20, height: 20))
        imageViewItem.contentMode = .scaleAspectFit
        imageViewItem.clipsToBounds = true
        mainContainer.addSubview(imageViewItem)
        
        //======= ADD LABEL TITLE INTO MAIN CONTAINER VIEW =======//
        lblItemName = UILabel(frame: CGRect(x: 50, y: 5, width: (mainContainer.frame.size.width - 90), height: 40))
        lblItemName.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblItemName.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblItemName.textAlignment = .left
        lblItemName.numberOfLines = 1
        lblItemName.layer.masksToBounds = true
        mainContainer.addSubview(lblItemName)
        
        //======== ADD SEPERATOR INTO MAIN CONTAINER VIEW ========//
        separatorView = UIView(frame: CGRect(x: 0, y: (mainContainer.frame.size.height - 1), width: mainContainer.frame.size.width, height: 1))
        separatorView.backgroundColor = MySingleton.sharedManager().themeGlobalSeperatorGreyColor
        mainContainer.addSubview(separatorView)
        
        self.addSubview(mainContainer)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
