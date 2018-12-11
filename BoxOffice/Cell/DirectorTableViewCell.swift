//
//  DirectorTableViewCell.swift
//  BoxOffice
//
//  Created by 김진형 on 07/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class DirectorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.actorLabel.adjustsFontSizeToFitWidth = true
        self.directorLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
