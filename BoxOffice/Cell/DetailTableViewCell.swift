//
//  datailTableViewCell.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var firstInfoLabel: UILabel!
    @IBOutlet weak var secondInfoLabel: UILabel!
    @IBOutlet weak var thirdInfoLabel: UILabel!
    @IBOutlet weak var ageImage: UIImageView!
    
    @IBOutlet weak var reservationRateLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.firstInfoLabel.adjustsFontSizeToFitWidth = true
        self.secondInfoLabel.adjustsFontSizeToFitWidth = true
        self.thirdInfoLabel.adjustsFontSizeToFitWidth = true
        
        self.reservationRateLabel.adjustsFontSizeToFitWidth = true
        self.userRatingLabel.adjustsFontSizeToFitWidth = true
        self.audienceLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
