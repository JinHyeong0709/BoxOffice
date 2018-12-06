//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let CollectionValueSender = NSNotification.Name("CollectionValueSender")
}

class CollectionViewController: UIViewController {
    let cellid = "collectionViewCell"
    @IBOutlet weak var settingBtn: UIBarButtonItem!
    var token: NSObjectProtocol?
    var movieList: [Movie] = []
    
    //    lazy var refresher: UIRefreshControl = {
    //        let refreshControl = UIRefreshControl()
    //        refreshControl.attributedTitle = NSAttributedString(string: "reload Data...")
    //        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    //        return refreshControl
    //    }()
    
    @IBOutlet weak var collectionListView: UICollectionView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            if let cell = sender as? ListCollectionViewCell {
                if let indexPath = collectionListView.indexPath(for: cell) {
                    let target = movieList[indexPath.item]
                    detailVC.receiveId = target.id
                }
            }
        }
    }
    
    func fetchURL(orderType: Int) {
        DispatchQueue.global().async {
            print(Thread.isMainThread ? "Collection Main Thread" : "Collection Background Thread")
            guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else { return }
            
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        print(Thread.isMainThread ? "Alert Main Thread" : "Alert Background Thread")
                        self.showErrorAlert(with:"\(error.localizedDescription)")
                    }
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let officeBoxResponse : OfficeBox = try JSONDecoder().decode(OfficeBox.self, from: data)
                    self.movieList = officeBoxResponse.movies
                    DispatchQueue.main.async {
                        self.collectionListView.reloadData()
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        self.showErrorAlert(with:"\(error.localizedDescription)")
                    }
                }
            }
            dataTask.resume()
        }
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
    
    @objc func showOption() {
        let sheetController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬하시겠습니까?", preferredStyle: .actionSheet)
        sheetController.addAction(UIAlertAction(title: "예매율", style: .default, handler: { (action : UIAlertAction) in
            DispatchQueue.global().async {
                NotificationCenter.default.post(name: NSNotification.Name.CollectionValueSender, object: nil, userInfo: ["orderType": 0])
            }
            return self.fetchURL(orderType: 0)
        }))
        sheetController.addAction(UIAlertAction(title: "큐레이션", style: .default, handler: { (action : UIAlertAction) in
            DispatchQueue.global().async {
                NotificationCenter.default.post(name: NSNotification.Name.CollectionValueSender, object: nil, userInfo: ["orderType": 1])
            }
            return self.fetchURL(orderType: 1)
        }))
        sheetController.addAction(UIAlertAction(title: "개봉일", style: .default, handler: { (action : UIAlertAction) in
            DispatchQueue.global().async {
                NotificationCenter.default.post(name: NSNotification.Name.CollectionValueSender, object: nil, userInfo: ["orderType": 2])
            }
            return self.fetchURL(orderType: 2)
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheetController.addAction(cancel)
        present(sheetController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name.TableValueSender, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            guard let type = notification.userInfo?["orderType"] as? Int else {
                return
            }
            self?.fetchURL(orderType: type)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingBtn.target = self
        self.settingBtn.action = #selector(showOption)
        
        fetchURL(orderType: 0)
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionListView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ListCollectionViewCell
        
        let movie: Movie = self.movieList[indexPath.item]
        cell.titleLabel.text = movie.title
        cell.ageImage?.image = UIImage(named: "ic_\(movie.grade)")
        cell.infoLabel.text = movie.collectionViewInfoText
        cell.dateLabel.text = "개봉일 : \(movie.date)"
        
        DispatchQueue.global().async {
            guard let posterURL = URL(string: movie.thumb) else { return }
            guard let imageData = try? Data(contentsOf: posterURL) else { return }
            
            DispatchQueue.main.async {
                if let index = self.collectionListView.indexPath(for: cell) {
                    if index.item == indexPath.item {
                        cell.posterImage?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let width = (collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right + layout.minimumLineSpacing)) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
}


