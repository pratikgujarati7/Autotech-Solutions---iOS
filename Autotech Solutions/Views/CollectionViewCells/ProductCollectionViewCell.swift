//
//  ProductCollectionViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 11/02/19.
//  Copyright © 2019 Autotech Solutions. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell
{
    
    var mainContainer: UIView = UIView()
    var mainImageView: UIImageView = UIImageView()
    var lblTitleBackground: UIView = UIView()
    var lblTitle: UILabel = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        var cellWidth:CGFloat
        var cellHeight:CGFloat
        
        cellWidth = frame.width
        cellHeight = frame.height
        
        //======= ADD MAIN CONTAINER VIEW =======//
        mainContainer = UIView(frame: CGRect(x: 5, y: 5, width: cellWidth - 10, height: cellHeight - 10))
        mainContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        //======= ADD IMAGE VIEW MAIN INTO MAIN CONTAINER VIEW =======//
        mainImageView = UIImageView(frame: CGRect(x: 30, y: 10, width: mainContainer.frame.size.width - 60, height: mainContainer.frame.size.width - 60))
        //mainImageView.image = UIImage(named: "share copy.png")!
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainContainer.addSubview(mainImageView)
        
        lblTitleBackground = UIView(frame: CGRect(x: 10, y: mainImageView.frame.origin.y + mainImageView.frame.size.height + 5, width:mainContainer.frame.size.width - 20, height: 2))
        lblTitleBackground.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor?.withAlphaComponent(0.5)
        mainContainer.addSubview(lblTitleBackground)
        
        //======= ADD LABEL IN CONTAINER VIEW =======//
        lblTitle = UILabel(frame: CGRect(x: 10, y: mainImageView.frame.origin.y + mainImageView.frame.size.height + 10, width:mainContainer.frame.size.width - 20, height: cellHeight - mainImageView.frame.origin.y - mainImageView.frame.size.height - 30))
        lblTitle.numberOfLines = 0
        lblTitle.textAlignment = .left
        lblTitle.backgroundColor = .clear
        lblTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblTitle.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblTitle.adjustsFontSizeToFitWidth = true
        mainContainer.addSubview(lblTitle)
        
        self.contentView.addSubview(mainContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
