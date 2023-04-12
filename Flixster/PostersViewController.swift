//
//  PostersViewController.swift
//  Flixster
//
//  Created on 24/02/23.
//

import UIKit

class PostersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var mainCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    var movieArray = [movieData]()
    
    //for segue
    var clickedMovie:movieData!
    
    let tempName = "test.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.allowsSelection = true

        mainCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()
    }
    
    func fetchData() {
        refreshControl.beginRefreshing()
        
        let url = URL(string: "https://api.tmdb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                if error == nil {
                    let jsonData = try JSONDecoder().decode(mainData.self, from: data!)
                    
                    self.movieArray = jsonData.results
                    
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.mainCollectionView.reloadData()
                    }
                    
                }
            } catch {
                self.refreshControl.endRefreshing()
                print(error)
            }
        }
        task.resume()
    }
    
    @objc private func onPullToRefresh() {
        fetchData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.labelMovieName.text = self.movieArray[indexPath.row].original_title
        cell.imagePoster.imageFromLink(urlMain: "https://image.tmdb.org/t/p/w500\(self.movieArray[indexPath.row].poster_path ?? self.tempName)")
        
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickedMovie = self.movieArray[indexPath.row]
        
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (mainCollectionView.frame.size.width - 15) / 2
        return CGSize(width: size, height: size/0.5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let vc = segue.destination as! MovieDetailsController
            vc.clickedMovie = clickedMovie
        }
    }
}

extension UIImageView {
    public func imageFromLink(urlMain: String) {
        let url = URL(string: urlMain)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print(error)
            } else {
                if let _ = response as? HTTPURLResponse {
                    if let data = data {
                        DispatchQueue.main.async(execute: {() -> Void in
                            let image = UIImage(data: data)
                            self.image = image
                        })
                    }
                } else {
                    print("No response")
                }
            }
        }
        
        task.resume()
    }
}
