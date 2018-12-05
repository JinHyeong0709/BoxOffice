//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    let cellid = "collectionViewCell"
    
    var movieList: [Movie] = []
    
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "reload Data...")
//        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
//        return refreshControl
//    }()
    
    @IBOutlet weak var collectionListView: UICollectionView!
    
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
                    self.collectionListView.reloadData()
                }

            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
        //changeTitle(orderType: orderType)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchURL(orderType: 0)
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


