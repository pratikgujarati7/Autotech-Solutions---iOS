//
//  MyCarTableViewCell.swift
//  Autotech Solutions
//
//  Created by Dipen Lad on 29/12/18.
//  Copyright © 2018 Autotech Solutions. All rights reserved.
//

import UIKit
var MyCarTableViewCellHeight: CGFloat = 110

class MyCarTableViewCell: UITableViewCell {
    
    var mainContainer: UIView = UIView()
    var innerContainer: UIView = UIView()
    var lblCompanyName: UILabel = UILabel()
    var lblCarModel: UILabel = UILabel()
    var lblRegistrationNumber: UILabel = UILabel()
    var lblCarID: UILabel = UILabel()
    var imageViewDelete: UIImageView = UIImageView()
    var btnDelete: UIButton = UIButton()
    

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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: MyCarTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.white
        
        //======= ADD INNER CONTAINER VIEW =======//
        innerContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: MyCarTableViewCellHeight - 1))
        innerContainer.backgroundColor = MySingleton.sharedManager().themeGlobalLightestGreyColor
        mainContainer.addSubview(innerContainer)
        
        //======= ADD COMPANY NAME INTO MAIN CONTAINER VIEW =======//
        lblCompanyName = UILabel(frame: CGRect(x: 20, y: 15, width: (mainContainer.frame.size.width - 70), height: 20))
        lblCompanyName.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblCompanyName.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblCompanyName.textAlignment = .left
        lblCompanyName.numberOfLines = 1
        lblCompanyName.layer.masksToBounds = true
        innerContainer.addSubview(lblCompanyName)
        
        //======= ADD CAR MODEL INTO MAIN CONTAINER VIEW =======//
        lblCarModel = UILabel(frame: CGRect(x: 20, y: 45, width: (mainContainer.frame.size.width - 70), height: 20))
        lblCarModel.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblCarModel.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblCarModel.textAlignment = .left
        lblCarModel.numberOfLines = 1
        lblCarModel.layer.masksToBounds = true
        innerContainer.addSubview(lblCarModel)
        
        //======= ADD REGISTRATION NUMBER INTO MAIN CONTAINER VIEW =======//
        lblRegistrationNumber = UILabel(frame: CGRect(x: 20, y: 75, width: (mainContainer.frame.size.width - 70), height: 20))
        lblRegistrationNumber.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblRegistrationNumber.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblRegistrationNumber.textAlignment = .left
        lblRegistrationNumber.numberOfLines = 1
        lblRegistrationNumber.layer.masksToBounds = true
        innerContainer.addSubview(lblRegistrationNumber)
        
        //======= ADD CAR ID INTO MAIN CONTAINER VIEW =======//
        lblCarID = UILabel(frame: CGRect(x: (mainContainer.frame.size.width - 60), y: 15, width: 40, height: 30))
        lblCarID.font = MySingleton.sharedManager().themeFontThirtySizeBold
        lblCarID.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblCarID.textAlignment = .right
        lblCarID.numberOfLines = 1
        lblCarID.layer.masksToBounds = true
        innerContainer.addSubview(lblCarID)
        
        //======= ADD NOTIFICATION IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        imageViewDelete = UIImageView(frame: CGRect(x: (mainContainer.frame.size.width - 45) , y: 60, width: 25, height: 25))
        imageViewDelete.contentMode = .scaleAspectFit
        imageViewDelete.clipsToBounds = true
        imageViewDelete.image = UIImage(named: "delete.png")
        innerContainer.addSubview(imageViewDelete)
        
        btnDelete = UIButton(frame: CGRect(x: (mainContainer.frame.size.width - 45) , y: 60, width: 25, height: 25))
        btnDelete.tintColor = .clear
        btnDelete.setTitle("", for: .normal)
        innerContainer.addSubview(btnDelete)
        
        self.addSubview(mainContainer)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
