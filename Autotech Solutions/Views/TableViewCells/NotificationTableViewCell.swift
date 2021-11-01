//
//  NotificationTableViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 29/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
var NotificationTableViewCellHeight: CGFloat = 75

class NotificationTableViewCell: UITableViewCell {
    
    var mainContainer: UIView = UIView()
    var lblNotificationTitle: UILabel = UILabel()
    var lblNotificationText: UILabel = UILabel()
    
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
        
        //======== ADD LABLE NOTIFICATION TITLE INTO MAIN CONTAINER VIEW ========//
        lblNotificationTitle = UILabel(frame: CGRect(x: 10, y: 10, width: mainContainer.frame.size.width - 20, height: 20))
        lblNotificationTitle.textAlignment = .left
        lblNotificationTitle.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        lblNotificationTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblNotificationTitle.numberOfLines = 0
        mainContainer.addSubview(lblNotificationTitle)
        
        //======== ADD LABLE NOTIFICATION TEXT INTO MAIN CONTAINER VIEW ========//
        lblNotificationText = UILabel(frame: CGRect(x: 10, y: 40, width: mainContainer.frame.size.width - 20, height: 20))
        lblNotificationText.textAlignment = .left
        lblNotificationText.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblNotificationText.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblNotificationText.numberOfLines = 0
        mainContainer.addSubview(lblNotificationText)
        
        self.addSubview(mainContainer)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
