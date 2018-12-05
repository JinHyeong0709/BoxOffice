//
//  detailTableViewController.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class DetailTableViewController: UIViewController {

    let cellid = "detailTableViewCell"
    var receiveId: String?
    var info : MovieInfo?
    
    @IBOutlet weak var detailTableView: UITableView!
    
    func fetchURL(receiveId : String?) {
        guard let id = receiveId else { return }
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=\(id)") else { return }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let infoResponse : OfficeInfo = try JSONDecoder().decode(OfficeInfo.self, from: data)
                self.info = infoResponse.movieInfo
        
                DispatchQueue.main.async {
                    self.detailTableView.reloadData()
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
    
    
extension DetailTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! DetailTableViewCell

        print(info)
        if let info = self.info {
            cell.audienceLabel.text = "\(String(describing: info.audience))"
            cell.firstInfoLabel.text = info.title
        }
        
        return cell
    }
    
    
}

extension DetailTableViewController: UITableViewDelegate {
    
}
