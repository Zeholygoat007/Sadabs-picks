//
//  MovieDetailsController.swift
//  Flixster
//
//  Created on 16/02/23.
//

import UIKit

class MovieDetailsController: UIViewController {

    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieAverage: UILabel!
    @IBOutlet var movieVotes: UILabel!
    @IBOutlet var moviePopularity: UILabel!
    @IBOutlet var movieDescription: UILabel!
    
    //from segue
    var clickedMovie:movieData!
    
    let tempName = "test.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = clickedMovie.original_title
        movieAverage.text = "\(clickedMovie.vote_average) Vote Average"
        movieVotes.text = "\(clickedMovie.vote_count) Votes"
        moviePopularity.text = "\(clickedMovie.popularity) Popularity"
        movieDescription.text = clickedMovie.overview
        
        movieImage.imageFromLink(urlMain: "https://image.tmdb.org/t/p/w500\(clickedMovie.backdrop_path ?? self.tempName)")
        
    }
    
}
