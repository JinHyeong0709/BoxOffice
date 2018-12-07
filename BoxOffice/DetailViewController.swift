//
//  detailTableViewController.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with value: String ) {
        let alert = UIAlertController(title: "Error", message: value, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
class DetailViewController: UIViewController {
    
    let detailCellid = "detailTableViewCell"
    let commentCellid = "commentCell"
    var receiveId: String?
    var info: MovieInfo?
    var commentList: [Comment] = []
    
    @IBOutlet weak var detailTableView: UITableView!
    
    func fetchMovieInfoURL(receiveId : String? ) {
        guard let id = receiveId else { return }
        
        DispatchQueue.global().async {
            print(Thread.isMainThread ? "Detail Main Thread" : "Detail Background Thread")
            guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=\(id))") else { return }
            
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { [unowned self] (data, response, error) in
                print(url)
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.showErrorAlert(with:"\(error.localizedDescription)")
                    }
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let infoResponse : MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
                    self.info = infoResponse
                    print(infoResponse.actor)
                    print(infoResponse)
                    
                    DispatchQueue.main.async {
                        self.detailTableView.reloadData()
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        print(Thread.isMainThread ? "Alert Main Thread" : "Alert Background Thread")
                        self.showErrorAlert(with:"\(error.localizedDescription)")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchCommentURL(receiveId : String? ) {
        guard let id = receiveId else { return }
        guard let url2 = URL(string: "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)") else { return }
        
        let dataTask2 = URLSession(configuration: .default).dataTask(with: url2) { [unowned self] (data, response, error) in
            print(url2)
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showErrorAlert(with:"\(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let commentResponse : ComentsInfo = try JSONDecoder().decode(ComentsInfo.self, from: data)
                self.commentList =  commentResponse.comments
                print(self.commentList)
                DispatchQueue.main.async {
                    self.detailTableView.reloadData()
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    print(Thread.isMainThread ? "Alert Main Thread" : "Alert Background Thread")
                    self.showErrorAlert(with:"\(error.localizedDescription)")
                }
            }
        }
        
        dataTask2.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovieInfoURL(receiveId: receiveId)
        fetchCommentURL(receiveId: receiveId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = info?.title
    }
}


extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1,2:
            return 1
            
        case 3:
            return commentList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTableViewCell") as! DetailTableViewCell
            guard let target = info else { return cell }
            cell.firstInfoLabel.text = target.title
            cell.secondInfoLabel.text = "\(target.date)개봉"
            cell.thirdInfoLabel.text = "\(target.genre)/\(target.duration)분"
            cell.reservationRateLabel.text = "예매율\n\(target.reservationGrade)위 \(target.reservationRate)%"
            cell.userRatingLabel.text = "평점\n\(target.userRating)"
            cell.ageImage.image = UIImage(named: "ic_\(target.grade)")
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            if let audience = formatter.string(from: NSNumber(value: target.audience)) {
                cell.audienceLabel.text = "누적관객수\n\(audience)"
            }
            
            DispatchQueue.global().async {
                guard let posterURL = URL(string: target.image) else { return }
                guard let imageData = try? Data(contentsOf: posterURL) else { return }
                DispatchQueue.main.async {
                    cell.posterImage.image = UIImage(data: imageData)
                }
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "synopsisCell") as! SynopsisTableViewCell
            guard let target = info else { return cell }
            cell.synopsisLabel.text = target.synopsis
            
            return cell
            
        case 2: let cell = tableView.dequeueReusableCell(withIdentifier: "directorCell") as! DirectorTableViewCell
        guard let target = info else { return cell }
        cell.directorLabel.text = target.director
        cell.actorLabel.text = target.actor
        
        return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentsTableViewCell
            let target = commentList[indexPath.row]
            
            let formatter = DateFormatter()
            let timestamp = Date(timeIntervalSince1970: TimeInterval(target.timestamp))
            formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            let dateString = formatter.string(from: timestamp)
            
            cell.idLabel.text = target.writer
            cell.dateLabel.text = "\(dateString)"
            cell.commentLabel.text = target.contents
            
            return cell
            
        default:
            fatalError()
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
