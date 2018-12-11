//
//  detailTableViewController.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK:- Property
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var detailTableView: UITableView!
    var receiveId: String?
    var info: MovieInfo?
    var commentList: [Comment] = []
    private let cellId = "detailTableViewCell"
    let fullStarImage = UIImage(named: "ic_star_large_full")!
    let halfStarImage = UIImage(named: "ic_star_large_half")!
    let emptyStarImage = UIImage(named: "ic_star_large")!
    
    //MARK:- fetchURL
    func fetchMovieInfoURL(receiveId : String? ) {
        guard let id = receiveId else { return }
        self.indicator.startAnimating()
        DispatchQueue.global().async {
            guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=\(id))") else { return }
            
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        self?.showErrorAlert(with:"\(error.localizedDescription)")
                    }
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                }
                
                do {
                    let infoResponse : MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
                    self?.info = infoResponse
                    
                    DispatchQueue.main.async {
                        self?.detailTableView.reloadData()
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        self?.showErrorAlert(with:"\(error.localizedDescription)")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchCommentURL(receiveId : String? ) {
        guard let id = receiveId else { return }
        self.indicator.startAnimating()
        guard let url2 = URL(string: "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)") else { return }
        
        let dataTask2 = URLSession(configuration: .default).dataTask(with: url2) { [weak self] (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.showErrorAlert(with:"\(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
            }
            
            do {
                let commentResponse : ComentsInfo = try JSONDecoder().decode(ComentsInfo.self, from: data)
                self?.commentList =  commentResponse.comments
                DispatchQueue.main.async {
                    self?.detailTableView.reloadData()
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    self?.showErrorAlert(with:"\(error.localizedDescription)")
                }
            }
        }
        
        dataTask2.resume()
    }
    
    //MARK:- Function
    func getUserRating(starNumber: Int, rating: Double) -> UIImage {
        let ratingInt = (Int(rating))
        let userRating = ratingInt / 2
        
        if ratingInt % 2 == 1 {
            if userRating >= starNumber {
                return fullStarImage
            } else if userRating + 1 == starNumber {
                return halfStarImage
            } else {
                return emptyStarImage
            }
        } else {
            if userRating >= starNumber {
                return fullStarImage
            } else {
                return emptyStarImage
            }
        }
    }
    
    //MARK:- Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("detail viewWillAppear")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("detail ViewDidDisappear")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("detail viewDidAppear")
        guard let target = info else { return }
        self.navigationItem.title = target.title
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("detail ViewDidLoad")
        self.fetchMovieInfoURL(receiveId: receiveId)
        self.fetchCommentURL(receiveId: receiveId)
        self.view.bringSubviewToFront(indicator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- Extension
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
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DetailTableViewCell
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
            
            cell.starImage1.image = getUserRating(starNumber: 1, rating: target.userRating)
            cell.starImage2.image = getUserRating(starNumber: 2, rating: target.userRating)
            cell.starImage3.image = getUserRating(starNumber: 3, rating: target.userRating)
            cell.starImage4.image = getUserRating(starNumber: 4, rating: target.userRating)
            cell.starImage5.image = getUserRating(starNumber: 5, rating: target.userRating)
            
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
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "directorCell") as! DirectorTableViewCell
            guard let target = info else { return cell }
            cell.directorLabel.text = target.director
            cell.actorLabel.text = target.actor
        
        return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentsTableViewCell
            let target = commentList[indexPath.row]
            
            let formatter = DateFormatter()
            let timestamp = Date(timeIntervalSince1970: TimeInterval(target.timestamp))
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let dateString = formatter.string(from: timestamp)
            
            cell.idLabel.text = target.writer
            cell.dateLabel.text = "\(dateString)"
            cell.commentLabel.text = target.contents
            
            cell.starImage1.image = getUserRating(starNumber: 1, rating: target.rating)
            cell.starImage2.image = getUserRating(starNumber: 2, rating: target.rating)
            cell.starImage3.image = getUserRating(starNumber: 3, rating: target.rating)
            cell.starImage4.image = getUserRating(starNumber: 4, rating: target.rating)
            cell.starImage5.image = getUserRating(starNumber: 5, rating: target.rating)
            
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.darkGray
        
        switch section {
        case 2:
            footerView.backgroundColor = UIColor.white
            return footerView
            
        default:
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0,1,2:
            return 5
        default:
            return 0
        }
    }
}

extension UIViewController {
    func showErrorAlert(with value: String ) {
        let alert = UIAlertController(title: "Error", message: value, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
