//
//  HomeTableViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 29/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
var HomeTableViewCellHeight: CGFloat = 100

class HomeTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var imageViewBackgroud: UIImageView = UIImageView()
    var lblItemName: UILabel = UILabel()
    var lblItemTitle: UILabel = UILabel()

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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: HomeTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.white
        
        //======= ADD NOTIFICATION IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        imageViewBackgroud = UIImageView(frame: CGRect(x: 0 , y: 0, width: mainContainer.frame.size.width, height: mainContainer.frame.size.height))
        imageViewBackgroud.contentMode = .scaleAspectFill
        imageViewBackgroud.clipsToBounds = true
        mainContainer.addSubview(imageViewBackgroud)
        
        //======= ADD LABEL NAME INTO MAIN CONTAINER VIEW =======//
        lblItemName = UILabel(frame: CGRect(x: 20, y: 25, width: (mainContainer.frame.size.width - 90), height: 20))
        lblItemName.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblItemName.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblItemName.textAlignment = .left
        lblItemName.numberOfLines = 1
        lblItemName.layer.masksToBounds = true
        mainContainer.addSubview(lblItemName)
        
        //======= ADD LABEL TITLE INTO MAIN CONTAINER VIEW =======//
        lblItemTitle = UILabel(frame: CGRect(x: 20, y: 45, width: (mainContainer.frame.size.width - 90), height: 30))
        lblItemTitle.font = MySingleton.sharedManager().themeFontTwentyFiveSizeBold
        lblItemTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblItemTitle.textAlignment = .left
        lblItemTitle.numberOfLines = 1
        lblItemTitle.layer.masksToBounds = true
        mainContainer.addSubview(lblItemTitle)
        
        self.addSubview(mainContainer)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
