//
//  utils.swift
//  BoxOffice
//
//  Created by 김진형 on 06/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
        func showErrorAlert(with value: String ) {
            let alert = UIAlertController(title: "Error", message: value, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
    
//    enum orderType: Int {
//        case reservationRate = 0 //default
//        case curation = 1
//        case openDate = 2
//    }
