//
//  ListCollectionViewCell.swift
//  BoxOffice
//
//  Created by 김진형 on 05/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ageImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.infoLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.dateLabel.adjustsFontSizeToFitWidth = true
    }
}
