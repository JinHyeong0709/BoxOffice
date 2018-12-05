//
//  ViewController.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var settingBtn: UIBarButtonItem!
    var movieList: [Movie] = []
    let cellid = "tableViewCell"
    let segueid = "showDetailSegue"
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "reload Data...")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    enum orderValue: Int {
        case reservationRate = 0 //default
        case curation = 1
        case openDate = 2
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailTableViewController {
            if let cell = sender as? ListTableViewCell {
                if let indexPath = listTableView.indexPath(for: cell) {
                    let target = movieList[indexPath.row]
                    detailVC.receiveId = target.id
                }
            }
        }
    }
        
        
        
        @objc func showOption() {
            let sheetController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬하시겠습니까?", preferredStyle: .actionSheet)
            
            sheetController.addAction(UIAlertAction(title: "예매율", style: .default, handler: { (action : UIAlertAction) in
                return self.fetchURL(orderType: orderValue.reservationRate.rawValue)
            }))
            
            sheetController.addAction(UIAlertAction(title: "큐레이션", style: .default, handler: { (action : UIAlertAction) in
                return self.fetchURL(orderType: orderValue.curation.rawValue)
            }))
            
            sheetController.addAction(UIAlertAction(title: "개봉일", style: .default, handler: { (action : UIAlertAction) in
                return self.fetchURL(orderType: orderValue.openDate.rawValue)
            }))
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            sheetController.addAction(cancel)
            
            present(sheetController, animated: true)
        }
        
        func fetchURL(orderType: Int) {
            guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else { return }
            
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let officeBoxResponse : OfficeBox = try JSONDecoder().decode(OfficeBox.self, from: data)
                    self.movieList = officeBoxResponse.movies
                    
                    DispatchQueue.main.async {
                        self.listTableView.reloadData()
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
            changeTitle(orderType: orderType)
        }
        
        
        func changeTitle(orderType: Int) {
            switch orderType {
            case 0:
                self.navigationItem.title = "예매일순"
            case 1:
                self.navigationItem.title = "큐레이션순"
            case 2:
                self.navigationItem.title = "개봉일순"
            default:
                return
            }
            
        }
        @objc func refreshData(_ sender: Any) {
            fetchURL(orderType: orderValue.reservationRate.rawValue)
            let deadline = DispatchTime.now() + .milliseconds(700)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.refresher.endRefreshing()
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            fetchURL(orderType: orderValue.reservationRate.rawValue)
        }
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "예매일 기준"
            if #available(iOS 10.0, *) {
                listTableView.refreshControl = refresher
            } else {
                listTableView.addSubview(refresher)
            }
            
            
            self.settingBtn.target = self
            self.settingBtn.action = #selector(showOption)
        }
        
    }
    
    extension TableViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movieList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = listTableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ListTableViewCell
            
            let movie: Movie = self.movieList[indexPath.row]
            cell.titleLabel.text = movie.title
            cell.ageImage?.image = UIImage(named: "ic_\(movie.grade)")
            cell.infoLabel.text = movie.tableViewInfoText
            cell.dateLabel.text = "개봉일 : \(movie.date)"
            
            DispatchQueue.global().async {
                guard let posterURL = URL(string: movie.thumb) else { return }
                guard let imageData = try? Data(contentsOf: posterURL) else { return }
                
                DispatchQueue.main.async {
                    if let index = self.listTableView.indexPath(for: cell) {
                        if index.row == indexPath.row {
                            cell.posterImage?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            return cell
        }
    }
    
    
    extension TableViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
}
