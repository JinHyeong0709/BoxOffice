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
    
    func fetchURL(receiveId id: String) {
        guard let id = receiveId else { return }
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=\(id)") else { return }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                self.showErrorAlert(with:"\(error.localizedDescription)")
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
                self.showErrorAlert(with:"\(error.localizedDescription)")
            }
        }
        dataTask.resume()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = receiveId {
            fetchURL(receiveId: id)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = info?.title
        // Do any additional setup after loading the view.
    }
}
    
    
extension DetailTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! DetailTableViewCell

        if let info = self.info {
            cell.audienceLabel.text = "\(String(describing: info.audience))"
            cell.firstInfoLabel.text = info.title
        }
        
        return cell
    }
    
    
}

extension DetailTableViewController: UITableViewDelegate {
    
}
