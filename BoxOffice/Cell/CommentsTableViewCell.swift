//
//  CommentsTableViewCell.swift
//  BoxOffice
//
//  Created by 김진형 on 06/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateLabel.adjustsFontSizeToFitWidth = true
        self.idLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
