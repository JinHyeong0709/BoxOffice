//
//  SynopsisTableViewCell.swift
//  BoxOffice
//
//  Created by 김진형 on 07/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class SynopsisTableViewCell: UITableViewCell {

    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
